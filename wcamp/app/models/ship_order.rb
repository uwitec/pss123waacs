class ShipOrder < ActiveRecord::Base
	require 'import_file'
	include ImportFile

	validates_uniqueness_of :work_line_no, :scope => [:work_no]	
	validates_presence_of :work_no, :work_line_no

	def device
		'-'
		#wc = WaccsCode.find_by_code(self.waacs_code)
		#wc.nil? ? '-' : wc.device
	end
end
