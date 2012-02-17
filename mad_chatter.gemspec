# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mad_chatter/version"

Gem::Specification.new do |s|
  s.name        = "mad_chatter"
  s.version     = MadChatter::VERSION
  s.authors     = ["Andrew Havens"]
  s.email       = ["email@andrewhavens.com"]
  s.homepage    = "http://github.com/andrewhavens/mad_chatter"
  s.summary     = %q{Mad Chatter is a fun, easy to customize chat server, utilizing HTML 5 Web Sockets}
  s.description = %q{Mad Chatter is a fun, easy to customize chat server, utilizing HTML 5 Web Sockets}

  # s.rubyforge_project = "mad_chatter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "eventmachine"
  s.add_runtime_dependency "em-websocket"
  s.add_runtime_dependency "daemons", "1.1.4"

  s.add_development_dependency "rspec"
  # s.add_development_dependency "shoulda" # do we need this?
  unless ENV["CI"]
    s.add_development_dependency 'simplecov'
    s.add_development_dependency 'guard'
    s.add_development_dependency 'guard-rspec'
    s.add_development_dependency 'rb-fsevent'
    s.add_development_dependency 'ruby-growl'
  end
end
