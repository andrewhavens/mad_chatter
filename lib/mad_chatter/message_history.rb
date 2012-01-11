module MadChatter
  class MessageHistory
    
    def self.add(message)
      @stack ||= []
      @stack << message
      @stack = @stack.pop(10) if @stack.length > 10
    end
    
    def self.all
      @stack ||= []
    end
    
    def self.clear
      @stack = []
    end
    
  end
end