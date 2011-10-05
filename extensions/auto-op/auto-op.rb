class AutoOpPlugin < Plugin
  
  def initialize
    add_hook(:join) {|m| op(m[:user], m[:channel]) }
    super
  end
  
end

plugin = AutoOpPlugin.new