require 'spec_helper'

describe MadChatter::MessageHistory do

  let (:history) { MadChatter::MessageHistory.new }
  
  before(:each) do
    
    # MadChatter::MessageHistory.clear
  end
  
  it 'should only keep 10 recent messages' do
    15.times do
      history.add MadChatter::Message.new('message', 'Here is a dummy chat message')
    end
    history.all.length.should == 10
  end

  it 'should allow you to clear the history' do
    history.add MadChatter::Message.new('message', 'Here is a dummy chat message')
    history.all.length.should == 1
    history.clear
    history.all.length.should == 0
  end
  
  context '#all' do
    it 'should still return an empty array if there is no chat history' do
      history.all.should == []
    end
  end
  
end
