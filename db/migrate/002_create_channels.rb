class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string :name
      t.string :topic
      
    end
  end
  
  def self.down
    drop_table :settings
  end
end