#!/usr/bin/env ruby

# Global flags
$debug = true

require 'bundler/setup'
# Libraries
require 'active_record'
require 'socket'
require 'colorize'

# Models
Dir[File.join(File.dirname(__FILE__), 'app', 'models', '*.rb')].each do |file|
  puts "Requiring #{file}..."
  require file
end

# IRCClient
puts "Requiring IRCClient..."
require File.join(File.dirname(__FILE__), 'lib', 'ircclient')

Dir[File.join(File.dirname(__FILE__), 'extensions', '**', '*.rb')].each do |file|
  puts "Requiring #{file}..."
  require file
end



class Bot  
  def initialize
    ActiveRecord::Base.establish_connection({
        :adapter => 'sqlite3',
        :database => 'db/development.db',
        :pool => 5,
        :timeout => 5000
    })
    
    @bot = IRCClient.new
    @bot.prepend_hook(:startup) { @bot.join "#robox2" }
    @bot.go!
  end
  
end

robox = Bot.new



