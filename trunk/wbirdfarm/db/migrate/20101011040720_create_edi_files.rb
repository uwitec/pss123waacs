class CreateEdiFiles < ActiveRecord::Migration
  def self.up
    create_table :edi_files do |t|
			t.string :class_name  # grouping name
			t.string :edi_code  # uniq name for tracing
			t.string :file_path # file path & name
			t.datetime :edi_at # uploaded or downloaded time.
      t.timestamps
    end
  end

  def self.down
    drop_table :edi_files
  end
end
