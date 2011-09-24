# Modules
Dir[File.join(File.dirname(__FILE__), 'ircclient_modules', '*.rb')].each {|file| require file }

class IRCClient
  
  @@hooks ||= {}

  include Hooks
  include Events
  include Actions
  include Raws
  include Utilities
  include CoreCallbacks
  
  def initialize    
  end
  
  def nickname
    @@nickname
  end
  
  def show_hooks
    @@hooks.inspect if $debug
  end
  
  def go!
    connect!
        
    loop do
      parse @@socket.gets
    end
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
    
    if /\d+/.match(raw)
      send("raw_#{raw}", raw) if respond_to? "raw_#{raw}"
      
    elsif raw == 'PRIVMSG'
      did_receive_privmsg!(target, message.join(' '))

    elsif raw == 'JOIN'
      # Handle new user and new channel
      if (user != @@nickname)
        did_receive_join!(user, target)
      else
        # Blow bubbles
      end

    elsif raw == 'KICK'
      did_receive_kick!(target, user, message.shift, message.join(' '))
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
