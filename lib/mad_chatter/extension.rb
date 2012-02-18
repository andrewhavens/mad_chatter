module MadChatter
  class Extension
    
    class << self
      def inherited(klass)
        MadChatter.message_listeners << klass.new
      end
    
      def on_message(regex, &block)
        alias_method :old_handle, :handle
        define_method(:handle) {
          if message.text =~ regex
            args = regex.match(message.original_text).captures
            block.call(args)
          end
        }
      end
    end
    
    attr_accessor :message
  
    def handle(message)
      # subclasses should override this function, or use the on_message shortcut method
    end
    
    def stop_message_handling
      raise "Don't call any more message listeners"
    end
  
    def send_message(text, from = nil)
      m = MadChatter::Message.new('message', text)
      m.username = from || @message.username
      m.channel = @message.channel
      MadChatter.send_message(m)
    end
  
    def send_status_message(text)
      MadChatter.send_message MadChatter::Message.new('status', text, nil, @message.channel)
    end
    
    def send_action(action, *args)
      m = MadChatter::Message.new('action')
      m.json = {function: action, args: args}
      m.channel = @message.channel
      MadChatter.send_message(m)
    end
  end
end