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

ActiveRecord::Schema.define(:version => 20101024021022) do

  create_table "casein_users", :force => true do |t|
    t.string   "login",                        :null => false
    t.string   "name"
    t.string   "email"
    t.string   "password",                     :null => false
    t.string   "salt",                         :null => false
    t.integer  "access_level",  :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ware_house_id"
  end

  create_table "edi_files", :force => true do |t|
    t.string   "class_name"
    t.string   "edi_code"
    t.string   "file_path"
    t.datetime "edi_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdf_path"
    t.integer  "ware_house_id"
    t.string   "edi_sub_code"
    t.string   "status"
  end

  create_table "goods", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "note"
    t.boolean  "is_fixed",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", :force => true do |t|
    t.string   "location"
    t.integer  "allocate_priority", :default => 0
    t.string   "goods_code"
    t.string   "goods_name"
    t.integer  "qty"
    t.integer  "ordered_qty"
    t.integer  "allocated_qty"
    t.string   "lot_no"
    t.date     "expiry_on"
    t.boolean  "is_fixed",          :default => true
    t.string   "picking_style",     :default => "single"
    t.integer  "ware_house_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "allocate_work_no"
  end

  create_table "orders", :force => true do |t|
    t.string   "order_no"
    t.date     "issued_on"
    t.string   "customer_code"
    t.string   "goods_code"
    t.integer  "order_qty"
    t.integer  "ware_house_id"
    t.integer  "shipping_address_id"
    t.string   "original_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "store_code"
    t.string   "allocate_status"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipping_addresses", :force => true do |t|
    t.string   "name"
    t.string   "customer_code"
    t.string   "zip_code"
    t.string   "address"
    t.string   "tel"
    t.string   "fax"
    t.string   "email"
    t.boolean  "is_fixed",      :default => true
    t.string   "picking_style", :default => "single"
    t.integer  "ware_house_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "ware_houses", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "allocate_priority", :default => 0
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
