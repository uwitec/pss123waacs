class Receive < ActiveRecord::Base
	require "import_file"
	include ImportFile
	require "export_file"
	include ExportFile
	
	attr_accessor :file

	def work_before_export file
		@file = file
	end
	
	def work_after_export
		edi_file = EdiFile.new(
			:class_name => 'received',
			:edi_code => 	File.basename(@file,'.*'), 
			:file_path => @file,
			:edi_at => DateTime.now
		)	
		edi_file.save
	end 
	
	def mysort_lines lines
		work_nos = []
		lines.each do |line|
			work_nos.push line.split(',')[0]
		end
		Receive.find(:all, :conditions => {:work_no => work_nos.uniq.compact}).each{|r| r.destroy}
		lines.map{|line| line unless [nil,'','work_no'].include?(line.split(',')[0])}.compact
	end
	
	def work_before_import file
		@file = file
	end
	
	def import_line column_and_value
		target = self.class.new
		column_and_value.each{ |col,value| target[col.to_sym] = value }
		target.edi_code = File.basename(@file,'.*')
		unless target.save
			$stderr.print(target.errors.full_messages.join("\n") + "\n")
		end
	end
	
	def work_after_import
		backup_file_name = $BACKUP_DIR + '/' + File.basename(@file) + '.bak'
		edi_file = EdiFile.new(
			:class_name => 'receiving',
			:edi_code => 	File.basename(@file,'.*'), 
			:file_path => backup_file_name,
			:edi_at => DateTime.now
		)	
		edi_file.save
	end 

	def show_status
		(r = ShipOrder::STATUS_TYPE.rassoc(self.status)) ? r[0] : '未処理'
	end
end
