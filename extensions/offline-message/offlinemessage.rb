class OfflineMessages < IRCClient

  def initialize
    add_hook(:join) {|m| send_message( m[:user] ) }
  end

  def send_message(username)
    @messages = Message.where(username: username)
  end

end

plugin = OfflineMessages.new
