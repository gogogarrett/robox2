class CreateOfflineMessages < ActiveRecord::Migration
  def self.up
    create_table :offline_messages do |t|
      t.string :username
      t.string :body
      t.string :recipient

      t.timestamps
    end
  end
  
  def self.down
    drop_table :offline_messages
  end
end
