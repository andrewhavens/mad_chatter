module MadChatter
  
  class Server
    
    def initialize(config)
      @config = config
      @server = initialize_server
    end
    
    def self.main_channel
      @main_channel ||= EventMachine::Channel.new
    end
    
    def initialize_server
      # TODO: Figure out a better (more flexible/dynamic) way to initialize the server class
      if @config['websocket_backend'] && @config['websocket_backend'] == 'MadChatter::Servers::EventMachineWebSocket'
        return MadChatter::Servers::EventMachineWebSocket.new(self, @config['websocket_port'])
      end
      
      raise 'You did not specify a valid class name for websocket_backend'
    end
  
    def start
      EM.run do
        puts "Starting Mad Chatter Web Socket server on port #{@config['websocket_port']}."
        @server.start
      end
    end
    
    def register_connection(&send_client_message_block)
      subscriber_id = MadChatter::Server.main_channel.subscribe(send_client_message_block)
      send_client_message_block.call(connection_token)
    end
    
    def connection_token
      token = Digest::SHA1.hexdigest Time.now.to_s
      MadChatter::Message.new('token', token).to_s
    end
    
    def connection_closed(id)
      MadChatter::Server.main_channel.unsubscribe(id)
    end
    
    def message_received(json)
      msg = JSON.parse(json)
      username = MadChatter::Users.find_username_by_token(msg['token'])
      message = MadChatter::Message.new(msg['type'], msg['message'], msg['token'], username)
      
      if message.token.nil?
        return # Token is required to send messages
      end
      
      begin
          MadChatter.simple_extensions.each do |extension|
          if message.text =~ extension[:regex]
            MadChatter::Action.instance_exec do
              args = extension[:regex].match(message.text).captures
              extension[:block].call(args)
            end
          end
        end
    
        MadChatter.extension_classes.each do |extension|
          extension.handle(message)
        end
        
        MadChatter::Server.send_json(message.to_s)
      rescue RuntimeError
        # dont need to do anything, just prevent any errors from stopping the server
      end
    end
    
    def self.send_json(json)
      MadChatter::Server.main_channel.push(json)
    end
    
  end

end
