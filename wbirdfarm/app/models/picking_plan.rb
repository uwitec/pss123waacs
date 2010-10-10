class PickingPlan #< ActiveRecord::Base
	
	def self.allocate 
		# total picking order allocation
		orders = Order.not_allocated.picking('total')
		return false if orders.size == 0
		customer_codes = orders.map{|order| order.customer_code}.uniq.compact
		orders_for = {}
		customer_codes.each do |customer_code|
			orders_for[customer_code] = orders.map{|order| order if order.customer_code == customer_code}.compact
			total_order = {}
			orders_for[customer_code].each do |order|
				if total_order[order.goods_code]
					total_order[order.goods_code] += order.order_qty
				else
					total_order[order.goods_code] = order.order_qty
				end
			end
			picking_list = []
			total_order.each do |goods_code, total_qty|
				balance_qty = total_qty
				inventories = Inventory.find(:all, :conditions => {:goods_code => goods_code})
				# todo add order_by or sort term.
				inventories.each do |inventory|
					sim_qty = inventory.sim_qty
					sim_qty >= balance_qty ?  pick_qty = balance_qty : pick_qty = sim_qty
					picking_list.push [inventory.id, customer_code, goods_code, inventory.location, pick_qty]
					inventory.allocated_qty = inventory.allocated_qty.to_i - pick_qty
					inventory.save
					balance_qty -= pick_qty
					break if balance_qty <= 0
				end
				picking_list.push [0, customer_code, goods_code, '-', balance_qty] if balance_qty > 0
			end	
			self.show_picking_list(picking_list)
		end
	end

	def self.allocated_qty_clear
		Inventory.find(:all).each{|inv| inv.allocated_qty = 0;inv.save}
	end

	private
	def self.show_picking_list report = []
		report.each do |line|
			line.each{ |item| $stdout.printf "%10s", item}
			$stdout.print("\n")
		end	
	end
end
