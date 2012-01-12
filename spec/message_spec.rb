require 'spec_helper' # see http://stackoverflow.com/q/5061179/314318

describe MadChatter::Message do
  let (:message) { MadChatter::Message.new('joy', 'I am the model of the modern major general') }

  it 'should have a well-known interface' do
    [:text, :to_json, :filter].each do |m|
      message.should respond_to(m)
    end
  end

  it 'should encode into JSON correctly' do
    message.to_json.should match /modern major general/
  end

  context '#filter' do
    it 'should remove <p> tags' do
      message.filter.should_not match /<[\s\\]*p[\s]*>/
    end
    
    it 'should be able to handle messages made of empty space' do
      message = MadChatter::Message.new('message', "    ")
      message.filter.should == ''
    end
    
    it 'should add target="_blank" to links' do
      message = MadChatter::Message.new('message', "[link me up](http://www.example.com)")
      message.filter.should match %r{<a target="_blank" href="http://www.example.com">link me up</a>}
    end
    
    it 'should also add target="_blank" to links that were autolinked' do
      message = MadChatter::Message.new('message', 'http://www.example.com')
      message.filter.should match %r{<a target="_blank" href="http://www.example.com">http://www.example.com</a>}
    end
  end

end
