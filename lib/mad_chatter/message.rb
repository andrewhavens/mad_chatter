require 'cgi'

module MadChatter
  class Message
    
    attr_accessor :type, :original_text, :filtered_text, :html, :json, :token, :channel, :growl, :add_to_history, :timestamp
    
    def initialize(type, text = nil, token = nil, channel_id = nil)
      @type = type
      if text
        @original_text = text
        @filtered_text = filter(text)
        @html = @filtered_text
        @growl = text
      end
      @token = token
      @channel = channel_id
      @add_to_history = true
      @timestamp = Time.now.to_i
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
    
    def user
      MadChatter.find_user_by_token(@token) if @token
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
        json: @json,
        username: username,
        channel: @channel,
        growl: @growl,
        time: @timestamp
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