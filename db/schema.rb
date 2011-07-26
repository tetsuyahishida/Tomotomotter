# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110712172330) do

  create_table "bottle_users", :force => true do |t|
    t.integer "bottle_id", :null => false
    t.integer "uid",       :null => false
  end

  add_index "bottle_users", ["bottle_id"], :name => "index_bottle_users_on_bottle_id"

  create_table "bottles", :force => true do |t|
    t.integer  "from_user",                      :null => false
    t.integer  "to_user"
    t.integer  "prev_bottle"
    t.text     "body",                           :null => false
    t.boolean  "reply_flag",  :default => true
    t.boolean  "last_flag",   :default => true
    t.boolean  "denied_flag", :default => false
    t.integer  "count",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bottles", ["to_user"], :name => "index_bottles_on_to_user"

  create_table "users", :force => true do |t|
    t.string   "provider",                      :null => false
    t.integer  "uid",                           :null => false
    t.string   "screen_name",                   :null => false
    t.string   "name",                          :null => false
    t.text     "token",                         :null => false
    t.text     "secret",                        :null => false
    t.boolean  "tweet_flag",  :default => true
    t.boolean  "active_flag", :default => true
    t.integer  "count",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid"

end
