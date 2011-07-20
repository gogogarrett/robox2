module Events

  # TODO: Rewrite this to be metaprogrammed - ie did_connect triggers connect, did_join triggers join
  
  def did_connect!
    triggers :connect
  end

  def did_join_channel!(channel)
    triggers :self_join, :channel => channel
  end
  
  def did_receive_response!(message)
    triggers :response, :message => message
  end
  
  def did_receive_privmsg!(message)
    triggers :privmsg, :message => message
  end
  
  def did_receive_notice!(message)
    triggers :notice, :message => message
  end

  def did_receive_startup_raw!
    triggers :startup_raw
  end

  def did_receive_raw!(numeric)
    triggers :raw, :numeric => numeric
  end

  def did_receive_join!(user, channel)
    triggers :join, :user => user, :channel => channel
  end
  

end
