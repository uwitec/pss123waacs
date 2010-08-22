class WorkOrder < ActiveRecord::Base

	def ship_orders
		ShipOrder.find(:all, :conditions => {:work_no => self.work_no})
	end

	def delivery_name
		ShipOrder.find(id).delivery_name
	end

	def status
		ship_orders.map{|s| s.status}.uniq.compact.join(",")	
	end

	def device
		ship_orders.map{|s| s.device}.uniq.compact.join(",")	
	end

	def order_lines
		ship_orders.size
	end
end
