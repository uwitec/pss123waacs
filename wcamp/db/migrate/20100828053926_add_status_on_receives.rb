class AddStatusOnReceives < ActiveRecord::Migration
  def self.up
		add_column :receives, :status, :string
  end

  def self.down
		remove_column :receives, :status
  end
end
