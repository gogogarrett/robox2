module Events

  # TODO: Rewrite this to be metaprogrammed - ie did_connect triggers connect, did_join triggers join
  
  def did_connect!
    triggers :connect
  end

  def did_join_channel!(channel)
    triggers :join, :channel => channel
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
  

end