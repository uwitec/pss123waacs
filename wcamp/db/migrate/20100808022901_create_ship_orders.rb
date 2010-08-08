class CreateShipOrders < ActiveRecord::Migration
  def self.up
    create_table :ship_orders do |t|
			t.string :work_no
			t.string :work_line_no
			t.string :location
			t.string :goods_code
			t.string :waacs_code
			t.float :order_qty
			t.float :result_qty
			t.string :user_code
			t.datetime :start_at
			t.datetime :end_at	
			t.string :goods_name
			t.string :delivery_name
			t.string :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :ship_orders
  end
end
