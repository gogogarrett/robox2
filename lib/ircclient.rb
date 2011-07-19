require 'socket'
require './lib/hooks.rb'
require './lib/events.rb'
require './lib/actions.rb'

class IRCClient
  include Hooks
  include Events
  include Actions
  
  attr_accessor :hooks
  
  def initialize
    @hooks ||= {}
    add_hook :connect, :on_connect
    add_hook :join, :on_join, :channel
    connect!
    
    loop do
      parse @socket.gets
    end
  end
  
  def on_connect
    join "#robox"
    join "#chat"
  end
  
  def on_join(channel)
    say channel, "HELLO, #{channel}!!"
  end
  
  def reply(message)
    puts ">> #{message}"
    @socket.puts message
  end
  
  
  def parse(message)
    message.strip!
    
    did_receive_response!(message)
    puts message
    
    sender, raw, target = *(message.split(" "))
    
    if /^PING (.+?)$/.match(message)
      reply "PONG #{$1}"
    
    elsif /\d+/.match(raw)
      send("handle_#{raw}", raw) if respond_to? "handle_#{raw}"
      
    elsif raw == 'PRIVMSG'
      did_receive_privmsg!(message)

    elsif raw == 'JOIN'
      # Handle new user and new channel
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