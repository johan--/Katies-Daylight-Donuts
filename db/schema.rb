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

ActiveRecord::Schema.define(:version => 20100414005834) do

  create_table "buy_backs", :force => true do |t|
    t.integer  "delivery_id"
    t.string   "state"
    t.integer  "tax",                :limit => 10
    t.integer  "price",              :limit => 10
    t.integer  "raised_donut_count"
    t.integer  "cake_donut_count"
    t.integer  "roll_count"
    t.integer  "donuthole_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clockin_times", :force => true do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",  :default => "Central Time (US & Canada)"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "deliveries", :force => true do |t|
    t.boolean  "delivered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "employee_id"
    t.string   "state"
    t.datetime "delivered_at"
    t.datetime "delivery_date"
    t.integer  "store_id"
    t.boolean  "locked"
    t.boolean  "paid",          :default => false
  end

  create_table "deliveries_items", :id => false, :force => true do |t|
    t.integer "delivery_id"
    t.integer "item_id"
  end

  create_table "delivery_presets", :force => true do |t|
    t.integer  "store_id"
    t.string   "day_of_week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed"
  end

  create_table "employees", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "position_type"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "born_on"
    t.integer  "clockin_id"
    t.string   "state"
  end

  create_table "employees_positions", :id => false, :force => true do |t|
    t.integer  "employee_id"
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",             :precision => 8, :scale => 2, :default => 0.0
    t.boolean  "available",                                       :default => true
    t.integer  "number_per_screen",                               :default => 25
    t.decimal  "weight",            :precision => 8, :scale => 2, :default => 0.0
  end

  create_table "line_items", :force => true do |t|
    t.integer "delivery_id"
    t.integer "item_id"
    t.integer "quantity"
    t.decimal "price",              :precision => 8, :scale => 2
    t.integer "delivery_preset_id"
    t.integer "buy_back_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "country"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "manager"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lat"
    t.string   "lng"
  end

  create_table "positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "employee_id"
    t.datetime "work_date"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "time_zone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "store_no"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "url"
    t.string   "lat"
    t.string   "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "city_id"
    t.integer  "position"
  end

  add_index "stores", ["position"], :name => "index_stores_on_position"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",         :default => "Central Time (US & Canada)"
    t.string   "api_key"
    t.boolean  "api_enabled",       :default => false
    t.string   "perishable_token",  :default => "",                           :null => false
    t.string   "user_type"
    t.boolean  "show_tips",         :default => true
    t.boolean  "show_hints",        :default => true
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
