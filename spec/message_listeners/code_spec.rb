require 'spec_helper'

describe MadChatter::MessageListeners::Code do

  let (:server) { MadChatter::Server.new({'websocket_backend' => 'MadChatter::Servers::EventMachineWebSocket'}) }
  let (:user) { MadChatter::User.new('usertoken') }
  let (:channel) { MadChatter::Channel.new('myroom') }
  let (:listener) { MadChatter::MessageListeners::Code.new }
  
  before(:each) do
    MadChatter.users = []
    MadChatter.channels = []
  end
  
  it 'should set html correctly' do
    MadChatter.users << user
    MadChatter.channels << channel
    begin
      message_text = <<-EOS
/code <?php
    echo "multiline";
    echo "code sample";
?>
EOS
      message = MadChatter::Message.new('message', message_text, user.token, channel.id)
      listener.handle(message)
      message.html.should == <<-EOS
<pre><?php
    echo "multiline";
    echo "code sample";
?></pre>
EOS
    rescue RuntimeError
    end
  end
  
end
