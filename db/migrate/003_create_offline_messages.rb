class CreateOfflineMessages < ActiveRecord::Migration
  def self.up
    create_table :offlinemessages do |t|
      t.string :username
      t.string :body
      t.string :recipient

      t.timestamps
    end
  end
  
  def self.down
    drop_table :offlinemessages
  end
end
