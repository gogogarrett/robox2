module Events

  # TODO: Rewrite this to be metaprogrammed - ie did_connect triggers connect, did_join triggers join
  
  def did_connect!
    triggers :connect
  end

  def did_join_channel!
    triggers :join
  end
  
  def did_receive_response!
    triggers :response
  end
  
  def did_receive_privmsg!
    triggers :privmsg
  end
  
  def did_receive_notice!
    triggers :notice
  end
  

end