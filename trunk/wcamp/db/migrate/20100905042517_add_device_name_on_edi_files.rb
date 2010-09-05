class AddDeviceNameOnEdiFiles < ActiveRecord::Migration
  def self.up
		add_column :edi_files, :device_name, :string
  end

  def self.down
		remove_column :edi_files, :device_name
  end
end
