require 'rspec'
require 'json'
require 'pretty_printer'
require 'textmate_puts_helper'

class MyClass
  include PrettyPrinter
  
  def as_json
    {:id => 1, :description => 'oddness', :emotion => 'confused'}
  end
end
  
describe "Meaningful debugging output in Textmate" do
    
  it "should actually display objects not just the # symbol" do
    puts "Let's see what is going on here..."
    pp MyClass.new
    MyClass.new.as_json.should be_nil # force rspec to fail so you can see how this is useful
  end
      
end