require 'daemons'

daemon_dir  = Dir.pwd + '/.daemon'
Dir::mkdir(daemon_dir) unless File.directory?(daemon_dir)

options = {
  :dir        => daemon_dir,
  :log_output => true,
  :multiple   => false, # only allow one daemon to run at a time
  :monitor    => true
}

Daemons.run_proc('Mad Chatter', options) do
  require 'mad_chatter'
  MadChatter.start
end