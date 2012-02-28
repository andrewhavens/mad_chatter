module MadChatter
  class Server
    
    def initialize(config)
      @config = config
      @server = initialize_server
    end
    
    def initialize_server
      return MadChatter::Servers::EventMachineWebSocket.new(@config['websocket_port'], self)
    end
  
    def start
      EM.run do
        puts "Starting Mad Chatter Web Socket server on port #{@config['websocket_port']}."
        @server.start
      end
    end
    
  end

end
