class NumberMaster < ActiveRecord::Base

	def new_number
		self.last_num += 1
		self.last_num = self.min_num if self.last_num > self.max_num
		self.last_num
	end

	def self.new_picking_work_no
		num = NumberMaster.find_by_code('picking_work_no')
		new_number = num.prefix.to_s + num.new_number.to_s
		num.save
		new_number
	end
	
	def self.new_receive_no
		num = NumberMaster.find_by_code('receive_no')
		new_number = num.prefix.to_s + num.new_number.to_s
		num.save
		new_number
	end
end
