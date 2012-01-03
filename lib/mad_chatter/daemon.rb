require 'daemons'

daemon_dir  = Dir.pwd + '/.daemon'
Dir::mkdir(daemon_dir) unless File.directory?(daemon_dir)

options = {
  :dir        => daemon_dir,
  :log_output => true,
  :multiple   => false, # only allow one daemon to run at a time
  :monitor    => true
}

require 'mad_chatter'
config = MadChatter::Config.init
server = MadChatter::Server.new(config)

Daemons.run_proc('Mad Chatter', options) do
  server.start
end