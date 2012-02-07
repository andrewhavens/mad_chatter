module MadChatter
  module MessageListeners
    class Code
      
      include MadChatter::Actions
      
      @@regex = %r{^/code (.+)}
      
      def handle(msg)
        if msg.text =~ @@regex
          code = parse(msg.text)
          message = MadChatter::Message.new('message', nil, msg.token, msg.channel)
          message.html = "<pre>" + message.filter(code) + "</pre>"
          img_msg.growl = msg.username + ' has shared a code sample'
          channel = MadChatter::find_channel_by_id(msg.channel)
          channel.send_message(message)
          stop_message_handling
        end
      end
      
      def parse(message_text)
        @@regex.match(message_text).captures[0]
      end
      
    end
  end
end