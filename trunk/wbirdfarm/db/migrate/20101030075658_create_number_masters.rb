class CreateNumberMasters < ActiveRecord::Migration
  def self.up
    create_table :number_masters do |t|
			t.string :code
			t.string :name
			t.integer :last_num, :default => 1000
			t.integer :max_num, :default => 9999
			t.integer :min_num, :default => 1000
			t.string :prefix, :limit => 10
			t.string :surfix, :limit => 10
      t.timestamps
    end
		NumberMaster.create(:code => 'picking_work_no')
		NumberMaster.create(:code => 'receive_no')
  end

  def self.down
    drop_table :number_masters
  end
end
