require 'date'
require 'fileutils'

class ChatLogger < IRCClient
  
  def initialize
    add_hook(:privmsg) {|m| log_channel_message(m[:target], m[:user], m[:message])}
  end
  
  def log_channel_message(target, user, message)
    date = Date.today
    folder = File.join(File.dirname(__FILE__), '..', '..', 'logs', date.year.to_s, date.month.to_s, date.day.to_s)
    
    # Make folder.
    FileUtils.mkdir_p(folder) unless File.directory?(folder) 
    
    logfile = File.join(folder, target + '.txt')
  
    FileUtils.touch(logfile) unless File.exists?(logfile)
    File.open(logfile, 'a') {|f| f.puts "<#{user}> #{message}"}
  end
end

plugin = ChatLogger.new