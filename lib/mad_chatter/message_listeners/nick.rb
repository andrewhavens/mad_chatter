module MadChatter
  module MessageListeners
    class Nick
      
      include MadChatter::Actions
      
      @@regex = %r{^/nick (.+)}
      
      def handle(message)
        if @@regex =~ message.text
          username = parse_username(message.text)
          user = message.user
          if user
            user.update_username(username)
          end
          stop_message_handling
        end
      end
      
      def parse_username(text)
        @@regex.match(text).captures[0]
      end
      
    end
  end
end