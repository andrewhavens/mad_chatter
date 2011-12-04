module MadChatter
  class Extensions
    
    def self.load_simple_extensions(extensions)
      instance_eval extensions, __FILE__, __LINE__
    end
    
    def self.on_message(regex, &block)
      MadChatter.simple_extensions << { regex: regex, block: block }
    end
    
  end
end