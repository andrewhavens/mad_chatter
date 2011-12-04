module MadChatter
  class Action
    
    def self.inherited(extension_class)
      MadChatter.extension_classes << extension_class.new
    end    
    
    # Helper methods
    
    def stop_message_handling
      raise 'Dont call anymore message listeners'
    end
    
    def send_json(json)
      MadChatter::Server.send_json(json)
    end
    
    def send_message(text)
      message = MadChatter::Message.new('message', text)
      send_json(message.to_s)
    end
    
    def send_status_message(text)
      message = MadChatter::Message.new('status', text)
      send_json(message.to_s)
    end
    
    def send_users_list
      message = MadChatter::Message.new('users', MadChatter::Users.current)
      send_json(message.to_s)
    end
    
  end
end