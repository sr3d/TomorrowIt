# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090122045850) do

  create_table "chain_task_histories", :force => true do |t|
    t.integer "chain_task_id", :null => false
    t.integer "user_id",       :null => false
    t.date    "created_on"
  end

  add_index "chain_task_histories", ["chain_task_id", "created_on"], :name => "index_chain_task_histories_on_chain_task_id_and_created_on"

  create_table "chain_tasks", :force => true do |t|
    t.string   "name",       :limit => 250,                   :null => false
    t.integer  "user_id",                                     :null => false
    t.string   "color",      :limit => 30
    t.boolean  "is_active",                 :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chain_tasks", ["user_id"], :name => "index_chain_tasks_on_user_id"

  create_table "tasks", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",                            :null => false
    t.date     "due_date"
    t.datetime "done_date"
    t.boolean  "is_important", :default => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["user_id", "due_date"], :name => "index_tasks_on_user_id_and_due_date"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.boolean  "is_admin",                                 :default => false
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "token",                     :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.boolean  "is_chain_enabled",                         :default => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["token"], :name => "index_users_on_token", :unique => true

end
