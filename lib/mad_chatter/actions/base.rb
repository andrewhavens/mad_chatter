module MadChatter
  
  module Actions
    
    class Base
  
      def initialize(message, user_token)
        @message = message
        @user_token = user_token
      end
  
      def process
        send_message(@message)
      end
  
      def username
        MadChatter::Users.username(@user_token)
      end
      
      def send_status(message)
        MadChatter::Server.send_status(message)
      end
      
      def send_action(message)
        MadChatter::Server.send_action(message)
      end
  
      def send_message(message)
        MadChatter::Server.send_message(username, message)
      end
      
    end
    
  end
  
end