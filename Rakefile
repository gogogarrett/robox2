require './lib/ircclient.rb'

task :default => 'install'

desc "Creates database + schema and walks through basic settings to get bootstrapped."
task :install => :environment do
  puts "Migrating the database..."
  Rake::Task['db:migrate'].invoke

  puts ""
  puts "What server would you like to connect to? [e.g. irc.freenode.net?]"
  Setting.create({:name => 'server', :value => STDIN.gets.chomp})

  puts "What port should we connect to? [e.g. 6667]"
  Setting.create({:name => 'port', :value => STDIN.gets.chomp})
  
  puts "What should the bot's nickname be? [e.g. Robox]"
  Setting.create({:name => 'nickname', :value => STDIN.gets.chomp})
  
  puts ""
  puts "Good to go! You can start the bot now."
end


namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end
end

task :environment do 
  bot = IRCClient.new
end
