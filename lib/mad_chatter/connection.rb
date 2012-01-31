module MadChatter
  class Connection
    
    def register_connection(&send_message)
      subscriber_id = MadChatter::Server.main_channel.subscribe(send_message)
      token = generate_token
      send_message.call(MadChatter::Message.new('token', token).to_json)
      @subscribers[subscriber_id] = token
      MadChatter::MessageHistory.all.each do |json|
        send_message.call(json)
      end
      subscriber_id
    end
    
    def generate_new_token
      Digest::SHA1.hexdigest(Time.now.to_s)
    end
    
    def on_close
      token = @subscribers.delete(id)
      username = MadChatter::Users.find_username_by_token(token)
      MadChatter::Server.main_channel.unsubscribe(id)
      MadChatter::Users.remove(token)
      MadChatter::Server.send_json(MadChatter::Message.new('status', "#{username} has left the chatroom").to_json)
      MadChatter::Server.send_json(MadChatter::Message.new('users', MadChatter::Users.current).to_json)
    end
    
  end
end