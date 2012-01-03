module MadChatter
  module Actions
    class Base
    
      include MadChatter::Actions::Dsl
    
      def initialize(regex = nil, block = nil)
        @regex = regex
        @block = block
      end
    
      def handle(message)
        if message.original_text =~ @regex
          args = @regex.match(message.original_text).captures
          @block.call(args)
        end
      end
    
      # used to register a class that extends MadChatter::Actions::Base
      def self.inherited(extension_class)
        MadChatter.message_listeners << extension_class.new
      end
      
    end
  end
end