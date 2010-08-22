class CreateWaacsCodes < ActiveRecord::Migration
  def self.up
    create_table :waacs_codes do |t|
			t.string :code
			t.string :name
			t.string :device # device name
			t.string :device_code	# 識別コード
			t.string :logic # modelのメソッドを指定する
      t.timestamps
    end
  end

  def self.down
    drop_table :waacs_codes
  end
end
