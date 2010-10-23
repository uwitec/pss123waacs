class AddPdfPathOnEdiFiles < ActiveRecord::Migration
  def self.up
		add_column :edi_files, :pdf_path, :string
  end

  def self.down
		remove_column :edi_files, :pdf_path
  end
end
