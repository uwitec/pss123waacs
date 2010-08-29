class ShipOrder < ActiveRecord::Base
	require 'import_file'
	include ImportFile

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

	def device
		'-'
		#wc = WaccsCode.find_by_code(self.waacs_code)
		#wc.nil? ? '-' : wc.device
	end
	
	def show_status
		(r = ShipOrder::STATUS_TYPE.rassoc(self.status)) ? r[0] : '未処理'
	end
end
