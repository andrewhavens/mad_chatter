require 'spec_helper'

describe MadChatter::Message do

  before(:each) do
    MadChatter.users = []
    MadChatter.channels = []
  end
  
  it 'should have a well-known interface' do
    message = MadChatter::Message.new('message', 'my chat message')
    [:text, :to_json, :filter].each do |m|
      message.should respond_to(m)
    end
  end

  it 'should encode into JSON correctly' do
    message = MadChatter::Message.new('type', 'message', 'token', 'channel')
    message.timestamp = 1234567890
    message.to_json.should == '
      {
        "type":"type",
        "text":"message",
        "html":"message",
        "json":null,
        "username":null,
        "channel":"channel",
        "growl":"message",
        "time":1234567890
      }
    '.gsub(/\s+/, '') # remove the white space
  end
  
  context '#username' do
    let (:user) { MadChatter::User.new('usertoken', 'myusername') }
    let (:message) { MadChatter::Message.new('message', 'text', 'usertoken') }
    
    it 'should find username correctly' do
      MadChatter.users << user
      message.username.should == 'myusername'
    end
  end
  
  context '#filter' do
    
    let (:message) { MadChatter::Message.new('message', 'text') }
    
    it 'should escape all html tags' do
      html = "<strong>bold</strong><script>alert('text')</script>"
      message.filter(html).should == "&lt;strong&gt;bold&lt;/strong&gt;&lt;script&gt;alert('text')&lt;/script&gt;"
    end
    
    it 'should be able to handle messages made of empty space' do
      text = "    "
      message.filter(text).should == ''
    end

  end

end
