class Earthquake < MadChatter::Extension

  def handle(message)
    if message.text == '/earthquake'
      send_status_message "#{message.username} has just caused an earthquake!"
      send_action 'earthquake' # call a javascript function named 'earthquake'
      stop_message_handling
    end
  end

end