class ShipOrder < ActiveRecord::Base
	require 'import_file'
	include ImportFile
	attr_accessor :file

	validates_uniqueness_of :work_line_no, :scope => [:work_no]	
	validates_presence_of :work_no, :work_line_no

	STATUS_TYPE = [
		%w(未作業 10),
		%w(作業中 20),
		%w(作業済 30),
		%w(検品中 40),
		%w(検品済 50),
		%w(完了   90)
	].freeze
	
	def work_before_import file
		@file = file
	end

	def work_after_import
		backup_file_name = $BACKUP_DIR + '/' + File.basename(@file) + '.bak'
		edi_file = EdiFile.new(
			:class_name => 'shipping',
			:edi_code => 	File.basename(@file,'.*'), 
			:device_name => 'pdf_printer',
			:file_path => backup_file_name,
			:edi_at => DateTime.now
		)	
	end 
	
	def import_line column_and_value
		target = self.class.new
		column_and_value.each{ |col,value| target[col.to_sym] = value }
		target.edi_code = File.basename(@file,'.*')
		unless target.save
			$stderr.print(target.errors.full_messages.join("\n") + "\n")
		end
	end

	def device
		'-'
		#wc = WaccsCode.find_by_code(self.waacs_code)
		#wc.nil? ? '-' : wc.device
	end
	
	def show_status
		(r = ShipOrder::STATUS_TYPE.rassoc(self.status)) ? r[0] : '未処理'
	end
end
