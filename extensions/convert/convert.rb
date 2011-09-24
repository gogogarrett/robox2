class ConvertPlugin < IRCClient  
  
  def initialize
    add_hook(:command) {|m| route m[:target], m[:command] }
  end
  
  def route(target, command)
    if /\A(-?\d+)c to f\Z/i.match command
      say target, "#{$1}*C => \u0002#{c_to_f($1)}*F\u000f"
    elsif /\A(-?\d+)f to c\Z/i.match command
      say target, "#{$1}*F => \u0002#{f_to_c($1)}*C\u000f"
    end
  end
  
  def c_to_f(degrees)
    degrees.to_i * 1.8 + 32
  end
  
  def f_to_c(degrees)
    (degrees.to_i - 32) / 1.8
  end
  
end

plugin = ConvertPlugin.new