module MadChatter
  module MessageListeners
    class Code
      
      include MadChatter::Actions
      
      @@regex = %r{^/code (.+)}
      
      def handle(msg)
        if msg.original_text =~ @@regex
          code = parse(msg.original_text)
          message = MadChatter::Message.new('message', nil, msg.token, msg.channel)
          message.html = "<pre>" + message.filter(code) + "</pre>"
          message.growl = msg.username + ' has shared a code sample' if msg.username
          channel = MadChatter::find_channel_by_id(msg.channel)
          channel.send_message(message)
          stop_message_handling
        end
      end
      
      def parse(text)
        text.sub!('/code', '')
      end
      
    end
  end
end