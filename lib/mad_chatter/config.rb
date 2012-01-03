module MadChatter
  
  module Config
    class << self
      
      def init
        config = MadChatter::Config.initialize_config
        MadChatter::Config.initialize_extensions
        return config
      end
    
      def initialize_config
        config_file = File.join(Dir.pwd, 'config.yml')
        abort 'Could not find Mad Chatter config.yml file' unless File.exist?(config_file)
        
        config = YAML::load(File.open(config_file))
        defaults = {
          'websocket_backend' => 'websocket-rack',
          'websocket_port' => 8100,
        }
        @config = defaults.merge!(config)
      end

      def initialize_extensions
        simple_extensions_file = File.join(Dir.pwd, 'extensions.rb')
        if File.exist?(simple_extensions_file)
          file_contents = File.read(simple_extensions_file)
          MadChatter::Actions::Base.new.instance_eval file_contents
        end
        
        # Dir[Dir.pwd + '/extensions/*.rb'].each do |file|
        #   require file
        # end
      end
      
    end
  end
end
