module MadChatter
  class Message
    
    attr_accessor :type, :original_text, :filtered_text, :token, :username
    
    def initialize(type, original_text, token = nil, username = nil)
      @type = type
      @original_text = original_text
      @filtered_text = original_text  # if filter is never called, message will be original text
      @token = token
      @username = username
    end
    
    # Helper method for returning filtered text.
    def text
      @filtered_text
    end
    
    def to_json
      JSON.generate({
        type: @type,
        message: @filtered_text,
        username: @username,
      })
    end
    
    def filter
      @filtered_text = MadChatter.markdown.render(@original_text)
      @filtered_text = /^<p>(.*)<\/p>$/.match(@filtered_text)[1] # remove the <p> tags that markdown wraps by default
    end
    
  end
end