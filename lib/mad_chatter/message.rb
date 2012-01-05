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
      # remove the <p> tags that markdown wraps by default
      @filtered_text.sub!(/^<p>/, '')
      @filtered_text.sub!(/<\/p>$/, '')
      @filtered_text
    end
    
  end
end