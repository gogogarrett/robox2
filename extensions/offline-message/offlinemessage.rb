class OfflineMessages < Plugin

  def initialize
    add_hook(:join) { |m| send_message( m[:user] ) }
    add_hook(:command) { |m| route m[:target], m[:user], m[:command]  }
  end

  def route(target, user, command)
    if /\Atell (\S+)/i.match command
      save_message($1, $', user)
    end
  end

  def send_message(username)
    username = username.downcase
    @messages = OfflineMessage.where(username: username)
    if @messages
      @messages.each do |message|
        say username, "#{message.username} asked me to tell you: #{message.body} - at #{message.created_at}"
        message.destroy
      end
    end
  end

  def save_message(username, message, user)
    @message = OfflineMessage.create(username: username.downcase, body: message)
    say user, "Your message to #{username} will be sent when they login."
  end

end

plugin = OfflineMessages.new
