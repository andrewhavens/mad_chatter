require 'digest/sha1'
require 'mad_chatter/users'
require 'mad_chatter/message'

module MadChatter
  
  class Server
    
    def initialize(options = {})
      defaults = {
        :host => "0.0.0.0",
        :port => 8100
      }
      @options = defaults.merge!(options)
    end
    
    def self.main_channel
      @main_channel ||= EventMachine::Channel.new
    end
  
    def start
      EventMachine::WebSocket.start(@options) do |ws|
        
        ws.onopen do
          
          subscriber_id = MadChatter::Server.main_channel.subscribe { |msg| ws.send(msg) } #main send method, gets called when @main_channel.push gets called
          token = generate_token()
          send_client_token(ws, token)
          
          ws.onclose do
            username = MadChatter::Users.username(token)
            if username
              MadChatter::Server.send_status "#{username} has left the chatroom"
              MadChatter::Users.remove(token)
            end
            MadChatter::Server.main_channel.unsubscribe(subscriber_id)
          end
          
          ws.onmessage do |msg_json|
            msg = JSON.parse(msg_json)
            if msg['token'].nil?
              send_client_error(ws, 'Token is required')
            else
              message = MadChatter::MessageFactory.find(msg['message'], msg['token'])
              message.process
            end
          end
          
        end
      end
    end
    
    def generate_token
      Digest::SHA1.hexdigest Time.now.to_s
    end
    
    def send_client_error(client, message)
      data = JSON.generate({
        type: 'error',
        message: message
      })
      send_to_client(client, data)
    end
        
    def send_client_token(client, token)
      data = JSON.generate({
        type: 'token',
        message: token
      })
      send_to_client(client, data)
    end
    
    def send_to_client(client, data)
      client.send(data)
    end
    
    def self.send_users_list
      data = JSON.generate({
        type: 'users',
        message: MadChatter::Users.current
      })
      MadChatter::Server.push_to_all_connections(data)
    end
    
    def self.send_status(message)
      data = JSON.generate({
        type: 'status',
        message: message
      })
      MadChatter::Server.push_to_all_connections(data)
    end
    
    def self.send_message(username, message)
      data = JSON.generate({
        type: 'message',
        username: username,
        message: message
      })
      MadChatter::Server.push_to_all_connections(data)
    end
    
    def self.send_action(message)
      data = JSON.generate({
        type: 'action',
        message: message
      })
      MadChatter::Server.push_to_all_connections(data)
    end
    
    def Server.push_to_all_connections(data)
      # puts 'sending to all clients: ' + data
      MadChatter::Server.main_channel.push(data)
    end
  end

end