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

ActiveRecord::Schema.define(:version => 20100808051622) do

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

  create_table "inventories", :force => true do |t|
    t.string   "work_no"
    t.string   "location"
    t.string   "goods_code"
    t.string   "goods_name"
    t.float    "system_qty"
    t.float    "result_qty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receives", :force => true do |t|
    t.string   "work_no"
    t.string   "waacs_code"
    t.string   "goods_code"
    t.string   "location"
    t.float    "announced_qty"
    t.float    "result_qty"
    t.string   "user_code"
    t.string   "goods_name"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ship_orders", :force => true do |t|
    t.string   "work_no"
    t.string   "work_line_no"
    t.string   "location"
    t.string   "goods_code"
    t.string   "waacs_code"
    t.float    "order_qty"
    t.float    "result_qty"
    t.string   "user_code"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "goods_name"
    t.string   "delivery_name"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
