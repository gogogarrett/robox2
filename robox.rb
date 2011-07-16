#!/usr/bin/env ruby

require 'active_record'
require './app/models/setting.rb'
require './lib/ircclient.rb'


ActiveRecord::Base.establish_connection({
    :adapter => 'sqlite3',
    :database => 'db/development.db',
    :pool => 5,
    :timeout => 5000
})

bot = IRCClient.new