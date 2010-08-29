class AddMaxStatusOnWorkReceives < ActiveRecord::Migration
  def self.up
		execute "drop view work_receives"
		execute "create view work_receives as select work_no, max(id) as id, max(status) as max_status, count(*) as sum from receives group by work_no"
  end

  def self.down
		execute "drop view work_receives"
		execute "create view work_receives as select work_no, max(id) as id, count(*) as sum from receives group by work_no"
  end
end
