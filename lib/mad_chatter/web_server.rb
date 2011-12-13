require 'webrick'
web_server = WEBrick::HTTPServer.new(:Port => 3000, :DocumentRoot => Dir.pwd + '/web')
web_server.start