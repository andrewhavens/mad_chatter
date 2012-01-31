module MadChatter
  class Message
    
    attr_accessor :type, :original_text, :filtered_text, :html, :token, :channel, :growl, :add_to_history
    
    def initialize(type, text, token = nil, channel = nil)
      @type = type
      @original_text = text
      @filtered_text = filter(text)
      @html = @filtered_text
      @token = token
      @channel = channel
      @growl = text
      @add_to_history = true
    end
    
    def username=(username)
      @username = username
    end
    
    def username
      unless @username
        MadChatter.users.each do |user|
          @username = user.username if user.has_token?(@token)
        end
      end
      @username
    end
    
    # Helper method for returning filtered text.
    def text
      @filtered_text
    end
    
    def to_json
      JSON.generate({
        type: @type,
        text: @original_text,
        html: @html,
        username: username,
        growl: @growl,
      })
    end
    
    def filter(text)
      CGI::escapeHTML(text).strip
    end
    
    def add_to_history?
      @add_to_history
    end
    
  end
end