module MadChatter
  class User
    
    attr_accessor :token, :username
    
    def initialize(token = nil, username = nil)
      @token = token
      @username = username
    end
    
    def on_send(&blk)
      @on_send = blk
    end
    
    def send(json)
      @on_send.call(json) if @on_send
    end
    
    def connected
      # subscriber_id = MadChatter::Server.main_channel.subscribe(send_message)
      
      @token = generate_new_token unless @token
      MadChatter.users << self
      send_token
      send_channels
      
      # @subscribers[subscriber_id] = token
      # MadChatter::MessageHistory.all.each do |json|
      #   send_message.call(json)
      # end
      # subscriber_id
    end
    
    def generate_new_token
      Digest::SHA1.hexdigest(Time.now.to_s)
    end
    
    def send_token
      send JSON.generate({
        type: 'token',
        text: @token,
      })
    end
    
    def send_channels
      channels = MadChatter.channels.collect do |c|
        {:id => c.id, :name => c.name }
      end
      send JSON.generate({
        type: 'channels',
        json: channels,
      })
    end
    
    def update_username(username)
      @username = username
    end
    
    def disconnected
      MadChatter.channels.each do |channel|
        channel.remove_user(self)
      end
      # token = @subscribers.delete(id)
      # username = MadChatter::Users.find_username_by_token(token)
      # MadChatter::Server.main_channel.unsubscribe(id)
      # MadChatter::Users.remove(token)
      # MadChatter::Server.send_json(MadChatter::Message.new('status', "#{username} has left the chatroom").to_json)
      # MadChatter::Server.send_json(MadChatter::Message.new('users', MadChatter::Users.current).to_json)
    end
    
    def has_token?(token)
      @token == token
    end
  end
end