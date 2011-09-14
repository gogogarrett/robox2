#!/usr/bin/env ruby

require './lib/ircclient.rb'

bot = IRCClient.new

bot.add_hook(:self_join) {|m| bot.say m[:channel], "What up, dogs." }

bot.go!