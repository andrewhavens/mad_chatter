Gem::Specification.new do |s|
  s.name        = 'mad_chatter'
  s.version     = '0.1.0'
  s.date        = '2011-11-11'
  s.summary     = "Mad Chatter is a fun, easy to customize chat server, utilizing HTML 5 Web Sockets"
  s.description = "Mad Chatter is a fun, easy to customize chat server, utilizing HTML 5 Web Sockets"
  s.authors     = ["Andrew Havens"]
  s.email       = 'email@andrewhavens.com'
  s.homepage    = 'http://github.com/andrewhavens/mad_chatter'
  
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "templates/*", "templates/**/*", "LICENSE", "README.md"]
  s.require_path = 'lib'
  s.executables << 'mad_chatter'
  
  s.add_dependency 'thor', '~> 0.14.6'
  s.add_dependency 'eventmachine', '0.12.10'

end