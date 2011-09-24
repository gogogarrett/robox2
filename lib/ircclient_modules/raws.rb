module Raws

  def raw_004(message)
    # Trigger startup raw to allow on-connect stuff
    did_receive_startup_raw!
  end

end
