require 'spec_helper'

describe MadChatter::MessageListeners::ChannelCommands do

  let (:server) { MadChatter::Server.new({'websocket_backend' => 'MadChatter::Servers::EventMachineWebSocket'}) }
  let (:user) { MadChatter::User.new('usertoken') }
  let (:channel) { MadChatter::Channel.new('myroom') }
  let (:listener) { MadChatter::MessageListeners::ChannelCommands.new }
  
  before(:each) do
    MadChatter.users = []
    MadChatter.channels = []
  end
  
  it 'should allow a user to join a channel' do
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
  
  it 'should allow /join to exist in a normal message' do
    message = MadChatter::Message.new('message', 'this /join should not count')
    listener.handle(message)
    # how to check that nothing happened?
  end
  
  it 'should allow a user to create a channel' do
    MadChatter.users << user
    MadChatter.channels << channel
    begin
      MadChatter.find_channel_by_name('Foobar Room').should be_nil
      message = MadChatter::Message.new('message', '/channel create Foobar Room', user.token, channel.id)
      listener.handle(message)
      MadChatter.find_channel_by_name('Foobar Room').should_not be_nil
    rescue RuntimeError
    end
  end
  
end
