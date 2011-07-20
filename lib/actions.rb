module Actions

  def connect!
    server      = Setting.find_by_name('server').value
    port        = Setting.find_by_name('port').value
    @nickname   = Setting.find_by_name('nickname').value
    
    @socket     = TCPSocket.open(server, port)
    
    reply "USER #{@nickname} #{@nickname} #{@nickname} #{@nickname}"
    reply "NICK #{@nickname}"
    
    did_connect!
  end

  def join(channel)
    reply "JOIN #{channel}"
    debug "-- Calling did_join_channel! with channel #{channel}..."
    did_join_channel!(channel)
  end
  
  def say(target, message)
    reply "PRIVMSG #{target} :#{message}"
  end
  
  def set_mode(modestring)
    reply "MODE #{modestring}"
  end

  def op(user, channel)
    set_mode "#{channel} +o #{user}"
  end
end
