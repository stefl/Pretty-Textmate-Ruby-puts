module PrettyPrinter
  def self.included(c)
    c.class_eval do
      def pp *args
        puts JSON.pretty_generate(self.as_json)
      end
    end
  end
end