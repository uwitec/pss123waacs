class AddEdiCodeAndQualityStatus < ActiveRecord::Migration
  def self.up
		add_column :ship_orders, :edi_code, :string 
		add_column :receives, :edi_code, :string
		add_column :ship_orders, :quality_status, :string
		add_column :receives, :quality_status, :string
  end

  def self.down
		remove_column :ship_orders, :edi_code
		remove_column :receives, :edi_code
		remove_column :ship_orders, :quality_status
		remove_column :receives, :quality_status
  end
end
