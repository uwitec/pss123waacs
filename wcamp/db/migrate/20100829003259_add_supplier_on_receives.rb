class AddSupplierOnReceives < ActiveRecord::Migration
  def self.up
		add_column :receives, :supplier, :string
  end

  def self.down
		remove_column :receives, :supplier
  end
end
