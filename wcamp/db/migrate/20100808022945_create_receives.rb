class CreateReceives < ActiveRecord::Migration
  def self.up
    create_table :receives do |t|
			t.string :work_no
			t.string :waacs_code
			t.string :goods_code
			t.string :location
			t.float :announced_qty	
			t.float :result_qty
			t.string :user_code
			t.string :goods_name
			t.string :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :receives
  end
end
