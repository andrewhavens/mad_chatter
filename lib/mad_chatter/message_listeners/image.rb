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
          channel = MadChatter::find_channel_by_id(message.channel)
          channel.send_message(img_msg)
          stop_message_handling
        end
      end
      
      def parse_url(message_text)
        @@regex.match(message_text).captures[0]
      end
      
    end
  end
end