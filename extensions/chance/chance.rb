class ChancePlugin < Plugin

  def initialize
    add_hook(:command) {|m| route m[:target], m[:command] }
    super
  end

  def route(target, command)
    if /\A(\d+)d(\d+)\Z/.match command
      say target, "#{$1}d#{$2}: #{roll_dice($1, $2)}"
    end
    
    if /\A(.+?) or (.+?)\Z/.match command
      say target, flip_coin($1, $2)
    end
    
    if /\Acointoss\Z/.match command
      say target, flip_coin
    end
  end

  def roll_dice(die_count, sides)
    dice_rolled = []
    (1..die_count.to_i).inject(dice_rolled){|result, element| result << (rand(sides.to_i) + 1) }
    output = "\u0002#{dice_rolled.inject(&:+).to_s}\u000F => [" + dice_rolled.join(", ") + "]"
    output
  end
  
  def flip_coin(heads = "Heads", tails = "Tails")
    result = rand(2)
    result == 0 ? heads : tails
  end
  
end

plugin = ChancePlugin.new