module Events
  
  def did_connect!
    triggers :connect
  end

  def did_join_channel!
    triggers :join
  end

end