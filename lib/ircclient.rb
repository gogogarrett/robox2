require 'socket'
require 'colorize'
require './lib/hooks.rb'
require './lib/events.rb'
require './lib/actions.rb'
require './lib/raws.rb'
require './lib/utilities.rb'
$debug = false

class IRCClient
  include Hooks
  include Events
  include Actions
  include Raws
  include Utilities
  
  attr_accessor :hooks
  
  def initialize
    @hooks ||= {}
    add_hook :startup_raw, :on_startup
    add_hook :self_join, :on_self_join, :channel 
    add_hook :join, :on_join, :user, :channel
    connect!
    
    loop do
      parse @socket.gets
    end
  end
  
  def on_startup
    join "#robox"
    join "#robox2"
    join "#chat"
  end
  
  def on_self_join(channel)
    debug "Saying in #{channel}..."
    say channel, "HELLO, #{channel}!!"
  end

  def on_join(user, channel)
    op user, channel
  end
  
  def reply(message)
    chat ">> #{message}"
    @socket.puts message
  end
  
  
  def parse(message)
    message.strip!
    
    did_receive_response!(message)
    log message
    
    sender, raw, target = message.split " "
    user, hostname = sender.split "!"
    
    if /^PING (.+?)$/.match(message)
      reply "PONG #{$1}"
    
    elsif /\d+/.match(raw)
      send("raw_#{raw}", raw) if respond_to? "raw_#{raw}"
      
    elsif raw == 'PRIVMSG'
      did_receive_privmsg!(message)

    elsif raw == 'JOIN'
      # Handle new user and new channel
      if (user != @nickname)
        did_receive_join!(user, target.gsub(':', ''))
      else
        # Blow bubbles
      end

    elsif raw == 'KICK'
      # Handle removing channel and updating user
    elsif raw == 'MODE'
      # Handle updating channel modes
    elsif raw == 'PART'
      # Handle removing channel and updating user
    elsif raw == 'QUIT'
      # Handle updating user
    elsif raw == 'NICK'
      # Handle updating user
    elsif raw == 'TOPIC'
      # Handle updating channel
    
    end
    
  end
  
  
end
