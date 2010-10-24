class AddWareHouseOnEdiFiles < ActiveRecord::Migration
  def self.up
		add_column :edi_files, :ware_house_id, :integer
		add_column :edi_files, :edi_sub_code, :string
		add_column :edi_files, :status, :string
  end

  def self.down
		remove_column :edi_files, :ware_house_id
		remove_column :edi_files, :edi_sub_code
		remove_column :edi_files, :status
  end
end
