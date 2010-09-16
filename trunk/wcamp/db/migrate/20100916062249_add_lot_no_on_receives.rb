class AddLotNoOnReceives < ActiveRecord::Migration
  def self.up
		add_column :receives, :lot_no, :string
		add_column :receives, :expire_on, :date
  end

  def self.down
		remove_column :receives, :lot_no
		remove_column :receives, :expire_on
  end
end
