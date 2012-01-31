require 'spec_helper'

describe MadChatter::Server do

  it 'should accept new connections' do
    # todo
  end
  
  it 'should allow me to join a room that already exists' do
    # todo
  end
  
  it 'should not allow me to join a room that doesnt exist, unless I create it' do
    # todo
  end
  
  # context '#send_message' do
  #   it 'should add regular messages to the message history' do
  #     MadChatter::MessageHistory.all.length.should == 0
  #     message = MadChatter::Message.new('message', 'regular message');
  #     MadChatter::Server.send_message message
  #     MadChatter::MessageHistory.all.length.should == 1
  #   end
  #   it 'should add status messages to the message history' do
  #     MadChatter::MessageHistory.all.length.should == 0
  #     message = MadChatter::Message.new('status', 'status message');
  #     MadChatter::Server.send_message message
  #     MadChatter::MessageHistory.all.length.should == 1
  #   end
  #   it 'should not add action messages to the message history' do
  #     MadChatter::MessageHistory.all.length.should == 0
  #     message = MadChatter::Message.new('action', 'action message');
  #     MadChatter::Server.send_message message
  #     MadChatter::MessageHistory.all.length.should == 0
  #   end
  #   it 'should not add user list messages to the message history' do
  #     MadChatter::MessageHistory.all.length.should == 0
  #     message = MadChatter::Message.new('users', 'list of users');
  #     MadChatter::Server.send_message message
  #     MadChatter::MessageHistory.all.length.should == 0
  #   end
  # end
end