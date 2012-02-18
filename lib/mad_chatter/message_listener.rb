module MadChatter
  class MessageListener
    include MadChatter::Actions
    
    def initialize(regex = nil, block = nil)
      @regex = regex
      @block = block
    end
  
    def handle(message)
      if message.text =~ @regex
        args = @regex.match(message.original_text).captures
        @block.call(args)
      end
    end
  end
end