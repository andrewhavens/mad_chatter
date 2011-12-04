module MadChatter
  class Message
    
    attr_accessor :type, :text, :token, :username
    
    def initialize(type, message_text, token = nil, username = nil)
      @type = type
      @text = message_text
      @token = token
      @username = username
    end
    
    def to_s
      JSON.generate({
        type: @type,
        message: @text,
        username: @username,
      })
    end
    
  end
end