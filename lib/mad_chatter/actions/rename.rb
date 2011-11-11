module MadChatter
  
  module Actions
    
    class Rename < MadChatter::Actions::Base
      
      @@command = '/nick'
      
      def process
        old_username = username
        username = parse_username_from_message
        MadChatter::Users.update(@user_token, username)
        MadChatter::Server.send_users_list
        MadChatter::Server.send_status("#{old_username} is now known as #{username}")
      end
      
      def parse_username_from_message
        # clear the command from the message string
        # the rest will be the new username
        username = @message.sub("#{@@command} ", '')
      end
      
    end
    
  end
  
end