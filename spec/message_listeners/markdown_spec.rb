require 'spec_helper'

describe MadChatter::MessageListeners::Markdown do

  let (:listener) { MadChatter::MessageListeners::Markdown.new }
  
  it 'should autolink urls with target="_blank"' do
    message = MadChatter::Message.new('message', 'here is a link: http://example.com.')
    listener.handle(message)
    message.html.should == 'here is a link: <a target="_blank" href="http://example.com">http://example.com</a>.'
  end
  
  it 'should autolink email addresses' do
    message = MadChatter::Message.new('message', "feel free to email me at madchatter@example.com")
    listener.handle(message)
    message.html.should == 'feel free to email me at <a href="mailto:madchatter@example.com">madchatter@example.com</a>'
  end
  
  it 'should parse italics' do
    message = MadChatter::Message.new('message', "_this_ should have emphasis but this_one_should_not")
    listener.handle(message)
    message.html.should == '<em>this</em> should have emphasis but this_one_should_not'
    
    message = MadChatter::Message.new('message', "you can use *asterisks*")
    listener.handle(message)
    message.html.should == 'you can use <em>asterisks</em>'
    
    message = MadChatter::Message.new('message', "this _doesnt count either")
    listener.handle(message)
    message.html.should == 'this _doesnt count either'
  end
  
  it 'should parse bold' do
    message = MadChatter::Message.new('message', "here is a **strong** statement")
    listener.handle(message)
    message.html.should == 'here is a <strong>strong</strong> statement'
  end
  
  it 'should parse backticks as inline code' do
    message = MadChatter::Message.new('message', "this has `some code` in it")
    listener.handle(message)
    message.html.should == 'this has <code>some code</code> in it'
  end
  
  it 'should parse markdown style links' do
    message = MadChatter::Message.new('message', "[link me up](http://www.example.com)")
    listener.handle(message)
    message.html.should == '<a target="_blank" href="http://www.example.com">link me up</a>'
  end
  
end
