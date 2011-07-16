require 'socket'
require './lib/hooks.rb'
require './lib/events.rb'

class IRCClient
  include Hooks
  include Events
  
  attr_accessor :hooks
  
  def initialize
    @hooks ||= {}
    
    add_hook :connect, :join, "#robox"
    
    connect!
  end
  
  def connect!
    server      = Setting.find_by_name('server').value
    port        = Setting.find_by_name('port').value
    @nickname   = Setting.find_by_name('nickname').value
    
    @socket     = TCPSocket.open(server, port)
    
    raw "USER #{@nickname} #{@nickname} #{@nickname} #{@nickname}"
    raw "NICK #{@nickname}"
    
    did_connect!
  end
  
  def join(channel)
    raw "JOIN #{channel}"
    
    did_join_channel!
  end
  
  def raw(message)
    puts ">> #{message}"
    @socket.puts message
  end
  
end