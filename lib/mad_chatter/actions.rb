module MadChatter
  module Actions
    
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