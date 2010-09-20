class CreateWareHouses < ActiveRecord::Migration
  def self.up
    create_table :ware_houses do |t|
			t.string :warehouse_code
			t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :ware_houses
  end
end
