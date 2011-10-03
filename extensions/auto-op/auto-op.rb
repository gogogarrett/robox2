class AutoOpPlugin < IRCClient
  
  def initialize
    add_hook(:join) {|m| op(m[:user], m[:channel]) }
  end
  
end

plugin = AutoOpPlugin.new