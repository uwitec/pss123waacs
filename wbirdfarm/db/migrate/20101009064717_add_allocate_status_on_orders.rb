class AddAllocateStatusOnOrders < ActiveRecord::Migration
  def self.up
		add_column :orders, :allocate_status, :string
		add_column :inventories, :allocate_work_no, :string
  end

  def self.down
		remove_column :orders, :allocate_status
		remove_column :inventories, :allocate_work_no
  end
end
