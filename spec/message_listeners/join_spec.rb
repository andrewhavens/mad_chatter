require_relative '../spec_helper'

describe MadChatter::MessageListeners::Join do

  let (:server) { MadChatter::Server.new({'websocket_backend' => 'MadChatter::Servers::EventMachineWebSocket'}) }
  let (:user) { MadChatter::User.new('usertoken') }
  let (:channel) { MadChatter::Channel.new('myroom') }
  let (:listener) { MadChatter::MessageListeners::Join.new }
  
  before(:each) do
    MadChatter.users = []
    MadChatter.channels = []
  end
  
  it 'should add user to list of users in server and channel' do
    MadChatter.users << user
    MadChatter.channels << channel
    begin
      MadChatter.users.include?(user).should be_true
      MadChatter.find_channel_by_name('myroom').users.include?(user).should be_false
      message = MadChatter::Message.new('message', '/join', user.token, channel.id)
      listener.handle(message)
      MadChatter.find_channel_by_name('myroom').users.include?(user).should be_true
    rescue RuntimeError
    end
  end
  
  it 'should parse messages correctly' do
    message = MadChatter::Message.new('message', 'this /join should not count')
    listener.handle(message)
    # how to check that nothing happened?
  end
  
end
