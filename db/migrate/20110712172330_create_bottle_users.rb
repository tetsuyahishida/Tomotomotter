class CreateBottleUsers < ActiveRecord::Migration
  def self.up
    create_table :bottle_users do |t|
      t.integer :bottle_id, :null => false
      t.integer :uid, :null => false
    end
    add_index :bottle_users, [:bottle_id]
  end

  def self.down
    drop_table :bottle_users
  end
end
