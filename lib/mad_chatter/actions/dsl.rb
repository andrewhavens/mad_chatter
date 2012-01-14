module MadChatter
  module Actions
    module Dsl
      
      # Used to define a simple extension
      def on_message(regex, &block)
        MadChatter.message_listeners << MadChatter::Actions::Base.new(regex, block)
      end
      
      # Helper methods
    
      def stop_message_handling
        raise "Don't call any more message listeners"
      end
    
      def send_json(json)
        MadChatter::Server.send_json(json)
      end
    
      def send_message(text)
        MadChatter::Server.send_message MadChatter::Message.new('message', text)
      end
    
      def send_status_message(text)
        MadChatter::Server.send_message MadChatter::Message.new('status', text)
      end
    
      def send_users_list
        MadChatter::Server.send_message MadChatter::Message.new('users', MadChatter::Users.current)
      end
    
      def send_action(action, *args)
        MadChatter::Server.send_message MadChatter::Message.new('action', {function: action, args: args})
      end
      
    end
  end
end