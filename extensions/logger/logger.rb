require 'date'
require 'fileutils'

class ChatLogger < IRCClient
  
  def initialize
    add_hook(:privmsg) {|m| log_channel_message(m[:target], m[:user], m[:message])}
  end
  
  def log_channel_message(target, user, message)
    date = Date.today
    time = Time.now.strftime('%H:%M')
    folder = File.join(File.dirname(__FILE__), '..', '..', 'logs', date.year.to_s, date.month.to_s, date.day.to_s)
    
    # Make folder.
    FileUtils.mkdir_p(folder) unless File.directory?(folder) 
    
    logfile = File.join(folder, target + '.html')
  
    unless File.exists?(logfile)
      debug "Creating log file."
      File.open(logfile, 'w') do |f|
        first_write = <<-EOS
<html>
<head>
  <title>#{date.year.to_s} - #{date.month.to_s} - #{date.day.to_s} -- #{target}</title>
</head>
<body>
<table>
  <tr>
    <td class="timestamp">#{time}<td>
    <td class="name">#{user}</td>
    <td class="text">#{message}</td>
  </tr>
EOS
      debug first_write
      f.puts first_write
      end
    else
      File.open(logfile, 'a') {|f| f.puts %(\t<tr>\n\t\t<td class="timestamp">#{time}</td>\n\t\t<td class="name">#{user}</td>\n\t\t<td class="text">#{message}</td>\n\t</tr>) }
    end
  end
end

plugin = ChatLogger.new