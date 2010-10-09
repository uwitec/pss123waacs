class PickingPlan #< ActiveRecord::Base
	
	def self.allocate 
		orders = Order.find(:all, :conditions => {:allocate_status => [nil,'']})			
		return false if orders.size == 0
		customer_codes = orders.map{|order| order.customer_code}.uniq.compact
		orders_for = []
		customer_codes.each do |customer_code|
			orders_for[customer_code] = orders.find(:all, :conditions => {:customer_code => customer_code})
			total_order = {}
			orders_for[customer_code].each do |order|
				if total_order[order.goods_code].nil? 
					total_order[order.goods_code] = order.order_qty
				else
					total_order[order.goods_code] += order.order_qty
				end
			end
			picking_list = []
			total_order.each do |goods_code, total_qty|
				balance_qty = total_qty
				inventories = Inventory.find(:all, :conditions => {:goods_code => goods_code})
				# todo add order_by or sort term.
				inventories.each do |inventory|
					sim_qty = inventory.sim_qty
					if sim_qty >= balance_qty
						pick_qty = balance_qty
						picking_list.push [inventory.id, inventory.location, goods_code, pick_qty]
					else
						pick_qty = sim_qty
						picking_list.push [inventory.id, inventory.location, goods_code, pick_qty]
					end
					inventory.allocated_qty -= pick_qty
					inventory.save
					balance_qty -= pick_qty
					which balance_qty 
					break if balance_qty <= 0
				end
				picking_list.push [0, '-', goods_code, balance_qty] if balance_qty > 0
			end	
			p picking_list
		end
	end

	def allocated_qty_clear
		Inventory.find(:all).each{|inv| inv.allocated_qty = 0;inv.save}
	end
end
