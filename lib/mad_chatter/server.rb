module MadChatter
  class Server
    
    def initialize(config)
      @config = config
      @server = initialize_server
    end
    
    def initialize_server
      # TODO: Figure out a better (more flexible/dynamic) way to initialize the server class
      if @config['websocket_backend'] && @config['websocket_backend'] == 'MadChatter::Servers::EventMachineWebSocket'
        return MadChatter::Servers::EventMachineWebSocket.new(@config['websocket_port'], self)
      end
      
      raise 'You did not specify a valid class name for websocket_backend'
    end
  
    def start
      EM.run do
        puts "Starting Mad Chatter Web Socket server on port #{@config['websocket_port']}."
        @server.start
      end
    end
    
  end

end
