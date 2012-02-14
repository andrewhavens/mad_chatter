lib_dir = File.expand_path('..', __FILE__)
$:.unshift( lib_dir ) unless $:.include?( lib_dir )

require 'eventmachine'
require 'yaml'
require 'json'
require 'digest/sha1'

require 'mad_chatter/version'
require 'mad_chatter/config'

require 'mad_chatter/server'
require 'mad_chatter/servers/em_websocket'

require 'mad_chatter/channel'
require 'mad_chatter/user'

require 'mad_chatter/message'
require 'mad_chatter/message_history'

require 'mad_chatter/actions'
require 'mad_chatter/message_listeners/join'
require 'mad_chatter/message_listeners/markdown'
require 'mad_chatter/message_listeners/nick'
require 'mad_chatter/message_listeners/image'
require 'mad_chatter/message_listeners/code'

require 'mad_chatter/extensions'
require 'mad_chatter/message_listener'

module MadChatter
  
  class << self
    
    def users
      @users ||= []
    end
    
    def users=(array)
      @users = array
    end
    
    def find_user_by_token(token)
      users.each do |user|
        return user if user.token == token
      end
    end
    
    def channels
      @channels ||= []
    end
    
    def channels=(array)
      @channels = array
    end

    def find_channel_by_id(id)
      channels.each do |channel|
        return channel if channel.id == id
      end
    end
        
    def find_channel_by_name(name)
      channels.each do |channel|
        return channel if channel.name == name
      end
    end
    
    def message_listeners
      @message_listeners ||= []
    end
    
    def message_listeners=(array)
      @message_listeners = array
    end
    
    def start
      config = MadChatter::Config.init
      server = MadChatter::Server.new(config)
      server.start
    end
    
    def message_received(json)
      msg = JSON.parse(json)
      
      if msg['token'].nil?
        return # Token is required to send messages
      end
      
      message = MadChatter::Message.new('message', msg['message'], msg['token'], msg['channel'])
      
      begin
        message_listeners.each do |listener|
          listener.handle(message)
        end
        send_message(message)
      rescue RuntimeError
        # dont need to do anything, just prevent any errors from stopping the server
      end
    end
    
    def send_message(message)
      channels.each do |channel|
        channel.send_message(message) if channel.id == message.channel
      end
    end
    
  end
end