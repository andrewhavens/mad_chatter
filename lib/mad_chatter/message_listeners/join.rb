module MadChatter
  module MessageListeners
    class Join
      
      include MadChatter::Actions
      
      @@regex = %r{^/join$}
      
      def handle(message)
        if message.text =~ @@regex
          user = MadChatter.find_user_by_token(message.token)
          
          unless user && message.channel
            stop_message_handling # user should already exist, and channel id is required
          end
          
          channel = MadChatter.find_channel_by_id(message.channel)
          
          unless channel
            stop_message_handling # you cant join a channel that doesnt exist
          end
          
          channel.add_user(user)
          stop_message_handling
        end
      end
      
    end
  end
end