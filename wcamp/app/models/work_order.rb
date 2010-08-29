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
		e = ship_orders.map{|r| r.show_status}
		statuses = e.uniq.map{|x| [x, e.map{|y| y if y == x}.compact.size]}
		statuses.map{|s| s[0] + '(' + s[1].to_s + ')'}.join(" ")	
	end

	def device
		ship_orders.map{|s| s.device}.uniq.compact.join(" ")	
	end

	def order_lines
		ship_orders.size
	end
end
