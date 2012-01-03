module MadChatter
  module Actions
    class Join < MadChatter::Actions::Base
      
      @@regex = /\/join (.+)/
      
      def handle(message)
        if message.filtered_text =~ @@regex
          username = parse_username(message.filtered_text)
          MadChatter::Users.update(message.token, username)
          send_status_message "#{username} has joined the chatroom"
          send_users_list
          stop_message_handling
        end
      end
      
      def parse_username(text)
        @@regex.match(text).captures[0]
      end
      
    end
  end
end