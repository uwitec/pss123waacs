class AddWareHouseOnCaseinUsers < ActiveRecord::Migration
  def self.up
		add_column :casein_users, :ware_house_id, :integer
  end

  def self.down
		remove_column :casein_users, :ware_house_id
  end
end
