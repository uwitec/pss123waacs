class AddColumnCodeOnShippingAddressess < ActiveRecord::Migration
  def self.up
		add_column :shipping_addresses, :code, :string
		add_column :orders, :store_code, :string
  end

  def self.down
		remove_column :shipping_addresses, :code, :string
		remove_column :orders, :store_code, :string
  end
end
