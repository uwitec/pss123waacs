class CreateWareHouses < ActiveRecord::Migration
  def self.up
    create_table :ware_houses do |t|
			t.string :name
			t.string :code
			t.integer :allocate_priority, :default => 0
			t.integer :region_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ware_houses
  end
end
