module Utilities

  def debug(message)
     puts message.red if ($debug == true)
  end
  
  def log(message)
    puts message.cyan
  end

  def chat(message)
    puts message.magenta
  end

end
