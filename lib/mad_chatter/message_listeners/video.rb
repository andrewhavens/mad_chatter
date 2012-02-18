module MadChatter
  module MessageListeners
    class Video
      
      include MadChatter::Actions
      
      @@youtube = %r{^/youtube http://youtu.be/(.*)$}
      
      def handle(message)
        if message.original_text =~ @@youtube
          youtube_id = parse_youtube_id(message.original_text)
          img_msg = MadChatter::Message.new('message', nil, message.token, message.channel)
          img_msg.html = "<iframe width='560' height='315' src='http://www.youtube.com/embed/#{youtube_id}' frameborder='0' allowfullscreen></iframe>"
          img_msg.growl = message.username + ' has shared a YouTube video'
          MadChatter.send_message(message)
          stop_message_handling
        end
      end
      
      def parse_youtube_id(text)
        @@youtube.match(text).captures[0]
      end
      
    end
  end
end