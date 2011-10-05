module Events

  # TODO: Rewrite this to be metaprogrammed - ie did_connect trigger connect, did_join trigger join
  
  def did_connect!
    trigger :connect
  end

  def did_join_channel!(channel)
    trigger :self_join, {:channel => channel}
  end
  
  def did_receive_response!(message)
    trigger :response, {:message => message}
  end
  
  def did_receive_privmsg!(target, user, message)
    trigger :privmsg, {:target => target, :user => user, :message => message}
    
    if /\A!/.match message
      message.slice!(0)
      did_receive_command!(target, user, message)
    end
    
  end
  
  def did_receive_command!(target, user, command)
    trigger :command, {:target => target, :user => user, :command => command}
  end
  
  def did_receive_notice!(message)
    trigger :notice, {:message => message}
  end

  def did_receive_startup_raw!
    trigger :startup
  end

  def did_receive_raw!(numeric)
    trigger :raw, {:numeric => numeric}
  end

  def did_receive_join!(user, channel)
    trigger :join, {:user => user, :channel => channel}
  end
  
  # Channel, Abuser, User, Message
  def did_receive_kick!(channel, abuser, user, message)
    trigger :kick, {:channel => channel, :abuser => abuser, :user => user, :message => message}
  end
  
  def did_receive_nick_change!(old_nick, new_nick)
    trigger :nick_change, {:old_nick => old_nick, :new_nick => new_nick}
  end

  def did_receive_topic_change!(channel, topic)
    trigger :topic_change, {:channel => channel, :topic => topic}
  end
  
  def did_receive_part!(user, channel)
    trigger :part, {:user => user, :channel => channel}
  end 
  
  def did_receive_mode_change!(channel, modestring)
    trigger :mode_change, {:channel => channel, :modestring => modestring}
  end
  
  def did_receive_quit!(user)
    trigger :quit, {:user => user}
  end

end
