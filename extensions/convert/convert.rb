class ConvertPlugin < Plugin
  
  def initialize
    add_hook(:command) {|m| route m[:target], m[:command] }
    super
  end
  
  def route(target, command)
    if /\A(-?\d+)c to f\Z/i.match command
      say target, "#{$1}*C => \u0002#{c_to_f($1)}*F\u000f"
    elsif /\A(-?\d+)f to c\Z/i.match command
      say target, "#{$1}*F => \u0002#{f_to_c($1)}*C\u000f"
    elsif /\A(-?\d+)kgs to lbs\Z/i.match command
      say target, "#{$1}lbs => \u0002#{lbs_to_kgs($1)}kgs\u000f"
    elsif /\A(-?\d+)lbs to kgs\Z/i.match command
      say target, "#{$1}kgs => \u0002#{kgs_to_lbs($1)}lbs\u000f"
    elsif /\A(-?\d+)miles to kms\Z/i.match command
      say target, "#{$1}miles => \u0002#{miles_to_kms($1)}kms\u000f"
    elsif /\A(-?\d+)kms to miles\Z/i.match command
      say target, "#{$1}kms => \u0002#{kms_to_miles($1)}miles\u000f"
    end
  end
  
  def c_to_f(degrees)
    degrees.to_i * 1.8 + 32
  end
  
  def f_to_c(degrees)
    (degrees.to_i - 32) / 1.8
  end

  def lbs_to_kgs(pounds)
    convert = pounds.to_i / 2.2
    sprintf("%.2f", convert)
  end

  def kgs_to_lbs(pounds)
    convert = pounds.to_i * 2.2
    sprintf("%.2f", convert)
  end

  def miles_to_kms(distance)
    miles = distance.to_i * 1.6
  end

  def kms_to_miles(distance)
    km = distance.to_i * 0.6
  end
  
end

plugin = ConvertPlugin.new
