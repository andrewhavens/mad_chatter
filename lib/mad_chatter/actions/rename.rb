module MadChatter
  module Actions
    class Rename < MadChatter::Action
      
      @@regex = /\/nick (.+)/
      
      def handle(message)
        if message.text =~ @@regex
          old_username = message.username
          username = parse_username(message.text)
          MadChatter::Users.update(message.token, username)
          send_status_message "#{old_username} is now known as #{username}"
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