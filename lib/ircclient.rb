require 'socket'
require './lib/hooks.rb'
require './lib/events.rb'

class IRCClient
  include Hooks
  include Events
  
  attr_accessor :hooks
  
  def initialize
    @hooks ||= {}
    add_hook :connect, :on_connect
    
    connect!
    
    loop do
      parse @socket.gets
    end
  end
  
  def connect!
    server      = Setting.find_by_name('server').value
    port        = Setting.find_by_name('port').value
    @nickname   = Setting.find_by_name('nickname').value
    
    @socket     = TCPSocket.open(server, port)
    
    reply "USER #{@nickname} #{@nickname} #{@nickname} #{@nickname}"
    reply "NICK #{@nickname}"
    
    did_connect!
  end
  
  def on_connect
    join "#robox"
  end
  
  def join(channel)
    reply "JOIN #{channel}"
    
    did_join_channel!
  end
  
  def reply(message)
    puts ">> #{message}"
    @socket.puts message
  end
  
  def parse(message)
    message.strip!
    
    did_receive_response!
    puts message
    
    sender, raw, target = *(message.split(" "))
    
    if /^PING (.+?)$/.match(message)
      reply "PONG #{$1}"
    
    elsif /\d+/.match(raw)
      send("handle_#{raw}", raw) if respond_to? "handle_#{raw}"
      
    elsif raw == 'PRIVMSG'
      # Do something

    elsif raw == 'JOIN'
    elsif raw == 'KICK'
    elsif raw == 'MODE'
    elsif raw == 'PART'
    elsif raw == 'QUIT'  
    end
    
  end
  
  
end