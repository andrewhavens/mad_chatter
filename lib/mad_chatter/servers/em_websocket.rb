require 'em-websocket'

module MadChatter
  module Servers
    class EventMachineWebSocket
      
      def initialize(port, main_server)
        @main_server = main_server
        @config = {
          :host => '0.0.0.0',
          :port => port
        }
      end
      
      def start
        EventMachine::WebSocket.start(@config) do |ws|

          ws.onopen do
            
            user = MadChatter::User.new
            user.on_send { |msg| ws.send(msg) }
            ws.onclose { user.disconnected }
            ws.onmessage { |msg| @main_server.message_received(msg) }
            user.connected

            # connection_id = @main_server.register_connection do |msg|
            #   ws.send(msg)
            # end
            # 
            # ws.onclose do
            #   @main_server.connection_closed(connection_id)
            # end
            # 
            # ws.onmessage do |msg|
            #   @main_server.message_received(msg)
            # end

          end
        end
      end
      
    end
  end
end