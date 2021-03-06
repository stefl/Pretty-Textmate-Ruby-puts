Nicely formats debugging puts and pp statements in Textmate (for Rspec).

Sometimes you need to do things like this:

    puts "Let's see what is going on here..."
    pp MyClass.new
    
    
And usually see just this on the screen:

    Let's see what is going on here...
    #
    
You can right-click to inspect element, but that's a pain.

Drop the textmate_puts_helper.rb in your spec folder

    require 'textmate_puts_helper'
    
Watch as your objects appear as you would expect:

![Rspec debugging](https://img.skitch.com/20110219-ecx1pefh5eqtxxibcispcjikqg.png)

If you define a method 'pp' on any class instance, this will be used when using 'pp'.

For instance, I have a bunch of datamapper classes, and I want to see them in a nice format, so I do this:

    module PrettyPrinter
      def self.included(c)
        c.class_eval do
          def pp *args
            puts JSON.pretty_generate(self.as_json)
          end
        end
      end
    end
    
And in my class I add
    
    class MyClass < DataMapper::Resource
      include PrettyPrinter
      ...
      
I can then do this in spec:

    it "should have a programmer who understands what is going on in a strange scenario" do
      confusion = MyClass.create(:emotion => "confused", :description => "oddness")
      pp confusion
      confusion.should_not be_blank
    end
    
and see this output in the Textmate rspec window:

    {
      'id' => 1,
      'description' => "oddness",
      'emotion' => "confused"
    }
    
Hope this is of some use to someone!