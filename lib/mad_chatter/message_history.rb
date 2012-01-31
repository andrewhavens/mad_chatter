module MadChatter
  class MessageHistory
    
    def initialize
       @stack = []
    end
    
    def add(message)
      @stack << message
      @stack = @stack.pop(10) if @stack.length > 10
    end
    
    def all
      @stack
    end
    
    def clear
      @stack = []
    end
    
  end
end