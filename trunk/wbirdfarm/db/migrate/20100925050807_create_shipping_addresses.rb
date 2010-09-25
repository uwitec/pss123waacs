class CreateShippingAddresses < ActiveRecord::Migration
  def self.up
    create_table :shipping_addresses do |t|
			t.string :name
			t.string :customer_code
			t.string :zip_code
			t.string :address
			t.string :tel
			t.string :fax
			t.string :email
			t.boolean :is_fixed, :default => true
			t.string :picking_style, :default => 'single'
			t.integer :ware_house_id
      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_addresses
  end
end
