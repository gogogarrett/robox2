module CoreCallbacks
  
  def on_nick_change(m)
    say m[:new_nick], "You can't fool me, #{m[:old_nick]}. You may have a fancy new nickname like #{m[:new_nick]}, but you'll always be #{m[:old_nick]} to me."
  end
  
  def on_kick(m)
    if user == @nickname
      join m[:channel]
      say m[:channel], "You scum-bucket, #{m[:abuser]}! How DARE you kick me!!"
    else
      say m[:channel], "Haha! #{m[:user]} got kicked!"
    end
  end
  
  def on_startup
    join "#chat"
    join "#robox2"
  end

  def on_join(m)
    if m[:user] == 'Klael'
      say m[:channel], 'Klael sucks donkey cock.' 
    else
      op m[:user], m[:channel]
    end
  end
  
end