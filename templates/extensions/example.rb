class Example
  
  # include MadChatter::Extension
  
  def handle(message)
    if message.text == 'show me an example'
      send_status_message "#{message.username} really wants an example"
      send_message 'I said...I want an example!!!'
      stop_message_handling   # and don't let any other extensions handle it
    else
      # let other extensions handle it
    end
  end
  
end