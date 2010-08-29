class CreateWorkOrders < ActiveRecord::Migration
  def self.up
		execute "create view work_orders as select work_no, max(id) as id, max(start_at) as start_at, min(end_at) as end_at, max(status) as max_status, count(*) as sum from ship_orders group by work_no"
  end

  def self.down
		execute "drop view work_orders"
  end
end
