module MadChatter
  class Channel

    attr_accessor :id, :name, :users, :message_history

    def initialize(name = nil)
      @id = MadChatter.channels.count.to_s
      @name = name
      @users = []
      @message_history = MadChatter::MessageHistory.new
    end
    
    def add_user(user)
      @users << user
      send_users_list
      @message_history.all.each do |json|
        user.send(json)
      end
      send_message MadChatter::Message.new('status', "#{user.username} has joined the chatroom")
    end
    
    def remove_user(user)
      if @users.delete(user)
        send_message MadChatter::Message.new('status', "#{user.username} has left the chatroom")
        send_users_list
      end
    end
    
    def send_users_list
      usernames = []
      @users.each do |user|
        usernames << user.username
      end
      json = JSON.generate({
        type: 'users',
        json: usernames,
        channel: @id,
      })
      send_json(json)
    end
    
    def send_message(message)
      message.channel = @id
      json = message.to_json
      send_json(json)
      @message_history.add(json) if message.add_to_history?
    end
    
    def send_json(json)
      @users.each do |user|
        user.send(json)
      end
    end
    
  end
end