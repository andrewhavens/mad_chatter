module MadChatter
  module Extensions
    
    # include MadChatter::Actions
    
    # Used for defining simple extensions
    def on_message(regex, &block)
      MadChatter.message_listeners << MadChatter::MessageListener.new(regex, block)
    end
    
  end
end