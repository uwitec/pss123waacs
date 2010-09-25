class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
			t.string :location
			t.integer :allocate_priority, :default => 0
			t.string :goods_code
			t.string :goods_name
			t.integer :qty
			t.integer :ordered_qty
			t.integer :allocated_qty
			t.string :lot_no
			t.date :expiry_on
			t.boolean :is_fixed, :default => true
			t.string :picking_style , :default => 'single'
			t.integer :ware_house_id
      t.timestamps
    end
  end

  def self.down
    drop_table :inventories
  end
end
