require 'mad_chatter/actions'
require 'mad_chatter/actions/base'

module MadChatter
  
  class Message < MadChatter::Actions::Base; end

  class MessageFactory
  
    def self.find(message, user_token)
      MadChatter::Actions.registered_actions.each do |command, action_class|
        # puts "looping through registered actions, command: #{command}, action_class: #{action_class}"
        if message =~ /^#{command}/
          return eval(action_class).new(message, user_token)
        end
      end
      # puts 'could not find match for ' + message
      MadChatter::Message.new(message, user_token)
    end    
  end

end