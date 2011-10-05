class OfflineMessages < IRCClient

  def initialize
    add_hook(:join) { |m| send_message( m[:user] ) }
    add_hook(:command) { |m| route m[:target], m[:user], m[:command]  }
  end

  def route(target, user, command)
    if /\Atell (\w+) ([\w\s]+)\Z/i.match command
      save_message($1, $2)
    end
  end

  def send_message(username)
    @messages = OfflineMessage.where(username: username)
    if @messages
      @messages.each do |message|
        say username, "#{message.username} asked me to tell you: #{message.body} - at #{message.created_at}"
      end
    end
  end

  def save_message(username, message)
    @message = OfflineMessage.create(username: username.downcase, body: message)
  end

end

plugin = OfflineMessages.new
