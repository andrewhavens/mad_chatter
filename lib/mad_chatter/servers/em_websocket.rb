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
            ws.onmessage { |msg| MadChatter.message_received(msg) }
            user.connected
          end
        end
      end
      
    end
  end
end