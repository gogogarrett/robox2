module Events

  # TODO: Rewrite this to be metaprogrammed - ie did_connect triggers connect, did_join triggers join
  
  def did_connect!
    triggers :connect
  end

  def did_join_channel!(channel)
    triggers :self_join, {:channel => channel}
  end
  
  def did_receive_response!(message)
    triggers :response, {:message => message}
  end
  
  def did_receive_privmsg!(target, message)
    triggers :privmsg, {:target => target, :message => message}
  end
  
  def did_receive_notice!(message)
    triggers :notice, {:message => message}
  end

  def did_receive_startup_raw!
    triggers :startup_raw
  end

  def did_receive_raw!(numeric)
    triggers :raw, {:numeric => numeric}
  end

  def did_receive_join!(user, channel)
    triggers :join, {:user => user, :channel => channel}
  end
  
  # Channel, Abuser, User, Message
  def did_receive_kick!(channel, abuser, user, message)
    triggers :kick, {:channel => channel, :abuser => abuser, :user => user, :message => message}
  end
  
  def did_receive_nick_change!(old_nick, new_nick)
    triggers :nick_change, {:old_nick => old_nick, :new_nick => new_nick}
  end

  def did_receive_topic_change!(channel, topic)
    triggers :topic_change, {:channel => channel, :topic => topic}
  end
  
  def did_receive_part!(user, channel)
    triggers :part, {:user => user, :channel => channel}
  end 
  
  def did_receive_mode_change!(channel, modestring)
    triggers :mode_change, {:channel => channel, :modestring => modestring}
  end
  
  def did_receive_quit!(user)
    triggers :quit, {:user => user}
  end

end
