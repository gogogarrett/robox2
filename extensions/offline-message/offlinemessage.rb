class OfflineMessages < IRCClient

  def initialize
    add_hook(:join) { |m| send_message( m[:user] ) }
    add_hook(:command) { |m| route m[:target], m[:command]  }
  end

  def route(target, command)
    if /\Atell (\w+) (\w+\s)/i.match command
      save_message("#{$1}", "#{$2}")
    end
  end

  def send_message(username)
    @messages = ::Message.where(username: username)
    if @messages
      @messages.each do |message|
        say username, "#{message.username} asked me to tell you: #{message.body} - at #{message.created_at}"
      end
    end
  end

  def save_message(username, message)
    @message = ::Message.create(username: username, body: message)
  end

end

plugin = OfflineMessages.new
