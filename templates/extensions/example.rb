class MadChatterExtensionExample < MadChatter::Extension
  
  def handle(message)
    if message.text == 'show me an example'
      send_status_message "#{message.username} really wants an example"
      send_message 'I said...I want an example!!!'
      stop_message_handling
    end
    # ...otherwise, let other extensions have a chance at handling it
  end
  
end