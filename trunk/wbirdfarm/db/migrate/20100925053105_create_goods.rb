class CreateGoods < ActiveRecord::Migration
  def self.up
    create_table :goods do |t|
			t.string :name
			t.string :code
			t.string :note
			t.boolean :is_fixed, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :goods
  end
end
