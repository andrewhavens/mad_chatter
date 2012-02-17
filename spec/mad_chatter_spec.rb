require 'spec_helper'

describe MadChatter do
  
  before(:each) do
    MadChatter.users = []
    MadChatter.channels = []
  end
  
  it 'should provide the ability to find a channel by name' do
    channel = MadChatter::Channel.new('My special room')
    MadChatter.channels << channel
    MadChatter.find_channel_by_name('My special room').should == channel
    MadChatter.find_channel_by_name('doesnt exist').should == nil
  end
  
end