module MadChatter
  
  def self.simple_extensions
    @@simple_extensions ||= []
  end
  
  def self.extension_classes
    @@extension_classes ||= []
  end
  
  module Config
    class << self
      
      def init
        config = MadChatter::Config.initialize_config
        MadChatter::Config.initialize_extensions
        return config
      end
    
      def initialize_config
        config_file = File.join(Dir.pwd, 'config.yml')
      
        unless File.exist?(config_file)
          abort 'Could not find Mad Chatter config.yml file'
        end
        
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
          MadChatter::Extensions.load_simple_extensions(file_contents)
        end
        
        Dir[Dir.pwd + '/extensions/*.rb'].each do |file|
          require file
        end
      end
      
    end
  end
end
