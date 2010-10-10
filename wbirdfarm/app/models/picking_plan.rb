class PickingPlan #< ActiveRecord::Base
	# cf) picking_list format
	#  0              1           2           3         4         5         6
	# [customer_code, store_code, goods_code, location, pick_qty, order.id, inventory.id]
	#
	# cf) total_picking_list format
	#  0              1(2)        2(3)      3(4)      4(6)
	# [customer_code, goods_code, location, pick_qty, inventory.id]
	#
	# cf) feeding_list format
	#  0              1(1)        2(2)        3(4)      4(5)
	# [customer_code, store_code, goods_code, pick_qty, order.id]
	
	# total picking order allocation
	def self.allocate_total
		orders = Order.not_allocated.picking('total')
		return false if orders.size == 0
		pickings = self.allocate(orders)
		# total_picking_list
		total_pickings = {}
		pickings.each do |p|
			if total_pickings[p.values_at(0,2,3,4,6)] 			
				total_pickings[p.values_at(0,2,3,4,6)][3] += p[4]
			else
				total_pickings[p.values_at(0,2,3,4,6)] = p.values_at(0,2,3,4,6) 			
			end
		end
		self.show_picking_list(total_pickings.values)

		# feeding_list
		feedings = {}
		pickings.each do |p|
			if feedings[p.values_at(0,1,2,4,5)] 			
				feedings[p.values_at(0,1,2,4,5)][3] += p[4]
			else
				feedings[p.values_at(0,1,2,4,5)] = p.values_at(0,1,2,4,5) 			
			end
		end
		self.show_picking_list(feedings.values.sort{|a,b| a[0,1] <=> b[0,1]})
	end

	# single picking order allocation
	def self.allocate_single
		# todo sort or weight 
		orders = Order.not_allocated.picking('single')
		return false if orders.size == 0
		picking_list = self.allocate(orders)
		self.show_picking_list(picking_list.sort{|a,b| a.values_at(2,3,4,1) <=> b.values_at(2,3,4,1)})
	end

	def self.allocate orders	
		picking_list = []
		orders.each do |order|
			balance_qty = order.order_qty
			inventories = Inventory.find(:all, :conditions => {:goods_code => order.goods_code})
			inventories.each do |inventory|
				next if inventory.sim_qty <= 0
				sim_qty = inventory.sim_qty
				sim_qty >= balance_qty ?  pick_qty = balance_qty : pick_qty = sim_qty
				picking_list.push [order.customer_code, order.store_code, order.goods_code, inventory.location, pick_qty, order.id, inventory.id]
				inventory.allocated_qty = inventory.allocated_qty.to_i - pick_qty
				inventory.save
				balance_qty -= pick_qty
				break if balance_qty <= 0
			end
			picking_list.push [order.customer_code, order.store_code, order.goods_code, 'ZZZ', balance_qty, order.id, 0] if balance_qty > 0
		end	
		# todo changed allocated_status
		picking_list
	end

	def self.allocated_qty_clear
		Inventory.find(:all).each{|inv| inv.allocated_qty = 0;inv.save}
	end

	def self.show_picking_list report = []
		report.each do |line|
			line.each{ |item| $stdout.printf "%10s", item}
			$stdout.print("\n")
		end	
	end
end
