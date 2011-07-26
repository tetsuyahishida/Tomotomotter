class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider, :null => false
      t.integer :uid, :null => false
      t.string :screen_name, :null => false
      t.string :name, :null => false
      t.text :token, :null => false
      t.text :secret, :null => false
      t.boolean :tweet_flag, :default => true
      t.boolean :active_flag, :default => true
      t.integer :count, :default => 0

      t.timestamps
    end
    add_index :users, [:provider, :uid]
  end

  def self.down
    drop_table :users
  end
end
