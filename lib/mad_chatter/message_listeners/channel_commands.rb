module MadChatter
  module MessageListeners
    class ChannelCommands
      
      include MadChatter::Actions
      
      def handle(message)
        @message = message
        case @message.text
        when '/join'
          join_channel
          stop_message_handling
        when %r{^/channel create}
          create_channel
          stop_message_handling
        when %r{^/channel rename}
          rename_channel
          stop_message_handling
        end
      end
      
      def join_channel
        user = MadChatter.find_user_by_token(@message.token)
        
        unless user && @message.channel
          stop_message_handling # user should already exist, and channel id is required
        end
        
        channel = MadChatter.find_channel_by_id(@message.channel)
        
        unless channel
          stop_message_handling # you cant join a channel that doesnt exist
        end
        
        channel.add_user(user)
      end
      
      def create_channel
        channel_name = %r{^/channel create (.+)}.match(@message.text).captures[0]
        MadChatter.channels << MadChatter::Channel.new(channel_name)
        MadChatter.send_channels_list
      end
      
      def rename_channel
        channel_name = %r{^/channel rename (.+)}.match(@message.text).captures[0]
        channel = MadChatter.find_channel_by_id(@message.channel)
        channel.name = channel_name
        MadChatter.send_channels_list
      end
      
    end
  end
end