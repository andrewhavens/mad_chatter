module MadChatter
  module Extensions
    
    # include MadChatter::Actions
    
    # Used for defining simple extensions
    def self.on_message(regex, &block)
      MadChatter.message_listeners << MadChatter::MessageListener.new(regex, block)
    end
    
  end
end