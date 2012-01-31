module MadChatter
  module MessageListeners
    class Join
      
      include MadChatter::Actions
      
      @@regex = %r{^/join$}
      
      def handle(message)
        if message.text =~ @@regex
          # username = parse_username(message.text)
          user = MadChatter.find_user_by_token(message.token)
          # .update_username(username)
          if user && message.channel
            channel = MadChatter.find_channel_by_name(message.channel)
            if channel
              channel.add_user(user)
            end
            # send_status_message "#{user.username} has joined the chatroom"
            # send_users_list
          end
          stop_message_handling
        end
      end
      
      # def parse_username(text)
      #   @@regex.match(text).captures[0]
      # end
      
    end
  end
end