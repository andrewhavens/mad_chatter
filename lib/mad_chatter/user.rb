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
      @token = generate_new_token unless @token
      MadChatter.users << self
      send_token
      send_channels
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
      send MadChatter.channels_list
    end
    
    def update_username(username)
      old_username = @username
      @username = username
      send_users_list
      MadChatter.channels.each do |channel|
        channel.users.each do |user|
          if user == self
            channel.send_message MadChatter::Message.new('status', "#{old_username} is now known as #{@username}")
          end
        end
      end
    end
    
    def send_users_list
      MadChatter.channels.each do |channel|
        channel.users.each do |user|
          channel.send_users_list if user == self
        end
      end
    end
    
    def disconnected
      MadChatter.channels.each do |channel|
        channel.remove_user(self)
      end
    end
    
    def has_token?(token)
      @token == token
    end
  end
end