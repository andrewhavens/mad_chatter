module MadChatter
  class Extension
    include MadChatter::Actions
    
    attr_accessor :message
    
    def self.inherited(klass)
      MadChatter.message_listeners << klass.new
    end
  
    def handle(message)
      # subclasses should override this function, or use the on_message shortcut method
    end
    
  end
end