Gem::Specification.new do |s|
  s.name        = 'mad_chatter'
  s.version     = '0.0.1'
  s.date        = '2011-11-11'
  s.summary     = "Mad Chatter is a fun, easy to customize chat server written in Ruby utilizing HTML 5 Web Sockets"
  s.description = "Mad Chatter is a fun, easy to customize chat server written in Ruby utilizing HTML 5 Web Sockets"
  s.authors     = ["Andrew Havens"]
  s.email       = 'email@andrewhavens.com'
  s.homepage    = 'http://github.com/andrewhavens/mad_chatter'
  
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.executables << 'mad_chatter'
  
  # If you have other dependencies, add them here
  # s.add_dependency "another", "~> 1.2"

end