module MadChatter
  module Actions
    
    def stop_message_handling
      raise "Don't call any more message listeners"
    end
  
    # def send_json(json)
    #   MadChatter.send_json(json)
    # end
  
    def send_message(text, from)
      MadChatter.send_message MadChatter::Message.new('message', text, from)
    end
  
    def send_status_message(text)
      MadChatter.send_message MadChatter::Message.new('status', text)
    end
  
    # def send_users_list
    #   send_json MadChatter::Users.to_json
    # end
  
    def send_action(action, *args)
      MadChatter.send_message MadChatter::Message.new('action', {function: action, args: args})
    end
    
  end
end