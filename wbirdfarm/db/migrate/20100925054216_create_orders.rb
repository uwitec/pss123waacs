class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
			t.string :order_no
			t.date :issued_on
			t.string :customer_code
			t.string :goods_code
			t.integer :order_qty
			t.integer :ware_house_id
			t.integer :shipping_address_id
			t.string :original_data
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
