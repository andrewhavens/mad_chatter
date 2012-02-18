module MadChatter
  module MessageListeners
    class Image
      
      include MadChatter::Actions
      
      @@regex = %r{^/img (.+)}
      
      def handle(message)
        if message.text =~ @@regex
          img_url = parse_url(message.text)
          img_msg = MadChatter::Message.new('message', img_url, message.token, message.channel)
          img_msg.html = "<img src='#{img_url}'>"
          img_msg.growl = message.username + ' has shared an image'
          MadChatter.send_message(message)
          stop_message_handling
        end
      end
      
      def parse_url(message_text)
        @@regex.match(message_text).captures[0]
      end
      
    end
  end
end