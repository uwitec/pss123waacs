class CreateInventries < ActiveRecord::Migration
  def self.up
    create_table :inventries do |t|
			t.string :warehouse_code
			t.string :waacs_code
			t.string :location
			t.string :goods_code
			t.string :goods_name
			t.integer :qty
			t.integer :sim_qty
			t.integer :ordered_qty
			t.string :lot_no
			t.date :expiry_on
      t.timestamps
    end
  end

  def self.down
    drop_table :inventries
  end
end
