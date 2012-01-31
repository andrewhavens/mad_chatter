lib_dir = File.expand_path('..', __FILE__)
$:.unshift( lib_dir ) unless $:.include?( lib_dir )

require 'eventmachine'
# require 'redcarpet'
require 'yaml'
require 'json'
require 'digest/sha1'

require 'mad_chatter/version'
require 'mad_chatter/config'

require 'mad_chatter/server'
require 'mad_chatter/servers/em_websocket'

require 'mad_chatter/channel'
require 'mad_chatter/user'
require 'mad_chatter/users'

require 'mad_chatter/message'
require 'mad_chatter/message_history'

# require 'mad_chatter/actions/dsl'
# require 'mad_chatter/actions/base'
# require 'mad_chatter/actions/join'
# require 'mad_chatter/actions/rename'

require 'mad_chatter/actions'
require 'mad_chatter/message_listeners/join'
require 'mad_chatter/message_listeners/markdown'
require 'mad_chatter/message_listeners/nick'

module MadChatter
  
  # attr_accessor :users, :channels, :message_listeners
  
  class << self
    
    def users
      @users ||= []
    end
    
    def users=(array)
      @users = array
    end
    
    def channels
      @channels ||= []
    end
    
    def channels=(array)
      @channels = array
    end
    
    def message_listeners
      @message_listeners ||= []
    end
    
    def message_listeners=(array)
      @message_listeners = array
    end
    
    def find_user_by_token(token)
      users.each do |user|
        return user if user.token == token
      end
    end
    
    def find_channel_by_name(name)
      channels.each do |channel|
        return channel if channel.name == name
      end
    end
    
  end
  
  # def self.message_listeners
  #   @@message_listeners ||= []
  # end

  def self.start
    config = MadChatter::Config.init
    server = MadChatter::Server.new(config)
    server.start
  end
  
end