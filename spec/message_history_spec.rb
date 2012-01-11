require 'spec_helper'

describe MadChatter::MessageHistory do

  before(:each) do
    MadChatter::MessageHistory.clear
  end
  
  it 'should only keep 10 recent messages' do
    15.times do
      MadChatter::MessageHistory.add MadChatter::Message.new('message', 'Here is a dummy chat message')
    end
    MadChatter::MessageHistory.all.length.should == 10
  end

  it 'should allow you to clear the history' do
    MadChatter::MessageHistory.add MadChatter::Message.new('message', 'Here is a dummy chat message')
    MadChatter::MessageHistory.all.length.should == 1
    MadChatter::MessageHistory.clear
    MadChatter::MessageHistory.all.length.should == 0
  end
  
  context '#all' do
    it 'should still return an empty array if there is message chat history' do
      history = MadChatter::MessageHistory.all
      history.should == []
    end
  end
  
end
