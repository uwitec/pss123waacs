class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
			t.string :work_no
			t.string :location
			t.string :goods_code
			t.string :goods_name
			t.float :system_qty
			t.float :result_qty
      t.timestamps
    end
  end

  def self.down
    drop_table :inventories
  end
end
