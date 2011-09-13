# Libraries
require 'bundler/setup'
require 'socket'
require 'colorize'
require 'active_record'

# Models
require './app/models/setting.rb'

# Modules
require './lib/hooks.rb'
require './lib/events.rb'
require './lib/actions.rb'
require './lib/raws.rb'
require './lib/utilities.rb'

# Global flags
$debug = true

class IRCClient
  include Hooks
  include Events
  include Actions
  include Raws
  include Utilities
  
  attr_accessor :hooks
  attr_reader :nickname
  
  def initialize

    ActiveRecord::Base.establish_connection({
        :adapter => 'sqlite3',
        :database => 'db/development.db',
        :pool => 5,
        :timeout => 5000
    })
    
    
    @hooks ||= {}
    add_hook :startup_raw, :on_startup
    add_hook :self_join, :on_self_join, :channel 
    add_hook :join, :on_join, :user, :channel
    add_hook :kick, :on_kick, :channel, :abuser, :user, :message
    add_hook :nick_change, :on_nick_change, :old_nick, :new_nick
    connect!
    
    loop do
      parse @socket.gets
    end
  end
  
  def on_nick_change(old_nick, new_nick)
    say new_nick, "You can't fool me, #{old_nick}. You may have a fancy new nickname like #{new_nick}, but you'll always be #{old_nick} to me."
  end
  
  def on_kick(channel, abuser, user, message)
    if user == @nickname
      join channel
      say channel, "You scum-bucket, #{abuser}! How DARE you kick me!!"
    else
      say channel, "Haha! #{user} got kicked!"
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
    log message
    did_receive_response!(message)
    
    if /^PING (.+?)$/.match(message)
      reply "PONG #{$1}" and return
    end
    
    message = message.gsub(':', '').split(" ")
    sender, raw, target = message.shift(3)
    user, hostname = sender.split "!"
    
    # debug "-------------------------------------"
    # debug ""
    # debug "Sender: #{sender}"
    # debug "Raw: #{raw}"
    # debug "Target: #{target}"
    # debug "User: #{user}"
    # debug "Hostname: #{hostname}"
    # debug "Message: #{message}"
    # debug ""
    
    if /\d+/.match(raw)
      send("raw_#{raw}", raw) if respond_to? "raw_#{raw}"
      
    elsif raw == 'PRIVMSG'
      did_receive_privmsg!(target, message.join)

    elsif raw == 'JOIN'
      # Handle new user and new channel
      if (user != @nickname)
        did_receive_join!(user, target)
      else
        # Blow bubbles
      end

    elsif raw == 'KICK'
      did_receive_kick!(target, user, message.shift, message.join)
    elsif raw == 'MODE'
      did_receive_mode_change!(target, message)
    elsif raw == 'PART'
      did_receive_part!(user, target)
    elsif raw == 'QUIT'
      did_receive_quit!(user)
    elsif raw == 'NICK'
      # Old_Nick: User, New Nick: Target
      did_receive_nick_change!(user, target)
      # Handle updating user
    elsif raw == 'TOPIC'
      did_receive_topic_change!(target, message)
      # Handle updating channel
    
    end
    
  end
  
  
end
