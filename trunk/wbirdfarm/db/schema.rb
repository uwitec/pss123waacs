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

ActiveRecord::Schema.define(:version => 20100920072035) do

  create_table "casein_users", :force => true do |t|
    t.string   "login",                       :null => false
    t.string   "name"
    t.string   "email"
    t.string   "password",                    :null => false
    t.string   "salt",                        :null => false
    t.integer  "access_level", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventries", :force => true do |t|
    t.string   "warehouse_code"
    t.string   "waacs_code"
    t.string   "location"
    t.string   "goods_code"
    t.string   "goods_name"
    t.integer  "qty"
    t.integer  "sim_qty"
    t.integer  "ordered_qty"
    t.string   "lot_no"
    t.date     "expiry_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ware_houses", :force => true do |t|
    t.string   "warehouse_code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
