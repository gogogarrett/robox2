class OfflineMessages < IRCClient

  def initialize
    add_hook(:join) { |m| send_message( m[:user] ) }
  end

  def send_message(username)
    @messages = Message.where(username: username)
    if @messages
      @messages.each do |message|
        say username, "#{message.username} asked me to tell you: #{message.body} - at #{message.created_at}"
      end
    end
  end

end

plugin = OfflineMessages.new
