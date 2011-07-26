class CreateBottles < ActiveRecord::Migration
  def self.up
    create_table :bottles do |t|
      t.integer :from_user, :null => false
      t.integer :to_user, :default => nil
      t.integer :prev_bottle, :default => nil
      t.text :body, :null => false
      t.boolean :reply_flag, :default => true
      t.boolean :last_flag, :default => true
      t.boolean :denied_flag, :default => false
      t.integer :count, :default => 0

      t.timestamps
    end
    add_index :bottles, [:to_user]
  end

  def self.down
    drop_table :bottles
  end
end
