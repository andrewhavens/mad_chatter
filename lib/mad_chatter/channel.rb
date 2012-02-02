module MadChatter
  class Channel

    attr_accessor :id, :name, :users, :message_history

    def initialize(name = nil)
      @id = MadChatter.channels.count
      @name = name
      @users = []
      # @users = MadChatter::Users.new
      @message_history = MadChatter::MessageHistory.new
      # @em_channel = EventMachine::Channel.new
    end
    
    def add_user(user)
      @users << user
      send_message MadChatter::Message.new('status', "#{user.username} has joined the chatroom")
      send_users_list
    end
    
    def remove_user(user)
      @users.delete(user)
      send_message MadChatter::Message.new('status', "#{user.username} has left the chatroom")
      send_users_list
    end
    
    def send_message(message)
      json = message.to_json
      send_json(json)
      @message_history.add(json) if message.add_to_history?
    end
    
    def send_users_list
      usernames = []
      @users.each do |user|
        usernames << user.username
      end
      json = JSON.generate({
        type: 'users',
        json: usernames,
      })
      send_json(json)
    end
    
    def send_json(json)
      @users.each do |user|
        user.send(json)
      end
    end
    
  end
end