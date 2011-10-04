#!/usr/bin/env ruby

# Global flags
$debug = true

# Libraries
require 'bundler/setup'
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

puts "Requiring Plugin base..."
require File.join(File.dirname(__FILE__), 'lib', 'plugin')

Dir[File.join(File.dirname(__FILE__), 'extensions', '**', '*.rb')].each do |file|
  puts "Loading #{file}..."
  load file
end

class Bot  
  def initialize    
    @bot = IRCClient.new
    @bot.add_hook(:startup) { @bot.join "#robox2" }
    @bot.go!
  end
  
end

robox = Bot.new



