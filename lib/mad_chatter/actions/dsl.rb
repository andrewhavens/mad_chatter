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
        message = MadChatter::Message.new('message', text)
        send_json(message.to_json)
      end
    
      def send_status_message(text)
        message = MadChatter::Message.new('status', text)
        send_json(message.to_json)
      end
    
      def send_users_list
        message = MadChatter::Message.new('users', MadChatter::Users.current)
        send_json(message.to_json)
      end
    
      def send_action(action, *args)
        message = MadChatter::Message.new('action', {function: action, args: args})
        send_json(message.to_json)
      end
      
    end
  end
end