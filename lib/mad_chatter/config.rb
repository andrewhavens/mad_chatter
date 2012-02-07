module MadChatter
  
  module Config
    class << self
      
      def init
        config = init_config
        init_default_message_listeners
        init_extensions
        init_default_channels
        return config
      end
    
      def init_config
        config_file = File.join(Dir.pwd, 'config.yml')
        abort 'Could not find Mad Chatter config.yml file' unless File.exist?(config_file)
        
        config = YAML::load(File.open(config_file))
        defaults = {
          'websocket_backend' => 'websocket-rack',
          'websocket_port' => 8100,
        }
        @config = defaults.merge!(config)
      end
      
      def init_default_message_listeners
        %w{ Join Nick Image Code Markdown }.each do |listener|
          MadChatter.message_listeners << Object.const_get('MadChatter').const_get('MessageListeners').const_get(listener).new
        end
        # MadChatter.message_listeners << MadChatter::MessageListeners::Join.new
        # MadChatter.message_listeners << MadChatter::MessageListeners::Nick.new
        # MadChatter.message_listeners << MadChatter::MessageListeners::Image.new
        # MadChatter.message_listeners << MadChatter::MessageListeners::Code.new
        # MadChatter.message_listeners << MadChatter::MessageListeners::Markdown.new
      end

      def init_extensions
        simple_extensions_file = File.join(Dir.pwd, 'extensions.rb')
        if File.exist?(simple_extensions_file)
          file_contents = File.read(simple_extensions_file)
          # MadChatter::Extensions.module_eval file_contents
        end
        
        # Dir[Dir.pwd + '/extensions/*.rb'].each do |file|
        #   require file
        # end
      end
      
      def init_default_channels
        MadChatter.channels << MadChatter::Channel.new('default')
      end
      
    end
  end
end
