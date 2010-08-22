class WorkOrder < ActiveRecord::Base


	def self.active
		work_nos = ShipOrder.find(:all,
			:select => [:work_no], 
			:conditions => {:status => [:active, :trouble]}, 
			:order => "start_at")
		WorkOrder.find(:all, :conditions => {:work_no => work_nos})
	end
	
	def ship_orders
		ShipOrder.find(:all, :conditions => {:work_no => self.work_no})
	end

	def delivery_name
		ShipOrder.find(id).delivery_name
	end

	def status
		ship_orders.map{|s| s.status}.uniq.compact.join(" ")	
	end

	def device
		ship_orders.map{|s| s.device}.uniq.compact.join(" ")	
	end

	def order_lines
		ship_orders.size
	end
end
