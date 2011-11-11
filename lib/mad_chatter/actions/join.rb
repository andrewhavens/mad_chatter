module MadChatter
  
  module Actions
    
    class Join < MadChatter::Actions::Base
      
      @@command = '/join'
      
      def process
        username = parse_username_from_message
        MadChatter::Users.update(@user_token, username)
        MadChatter::Server.send_users_list
        MadChatter::Server.send_status("#{username} has joined the chatroom")
      end
      
      def parse_username_from_message
        # clear the command from the message string
        # the rest will be the new username
        username = @message.sub("#{@@command} ", '')
      end
      
    end
    
  end
  
end