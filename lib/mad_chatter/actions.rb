require 'mad_chatter/actions/base'
require 'mad_chatter/actions/join'
require 'mad_chatter/actions/rename'

module MadChatter

  module Actions
    
    class << self
    
      def config(&block)
        @config_block = block
      end
      
      def registered_actions
        @registered_actions
      end
    
      def init
        load_config_file
        load_default_actions
        load_action_extensions
      end
      
      def load_config_file
        if File.exists?('config.rb')
          load 'config.rb' # load up action extensions
        end
      end
      
      def load_default_actions
        @registered_actions = {}
        @registered_actions['/join'] = 'MadChatter::Actions::Join'
        @registered_actions['/nick'] = 'MadChatter::Actions::Rename'
      end
      
      def load_action_extensions
        config = MadChatter::Actions::Config.new
        @config_block.call(config) if @config_block
        config.actions.each do |command, action_class|
          @registered_actions[command] = action_class
        end
      end
    end
    
    class Config
      
      attr_accessor :actions
      
      def initialize
        @actions = {}
      end
      
      def add(command, action_class)
        @actions[command] = action_class
      end
    end
    
  end

end