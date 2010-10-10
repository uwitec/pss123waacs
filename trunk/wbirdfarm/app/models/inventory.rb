class Inventory < ActiveRecord::Base
	belongs_to :ware_house
	
	validates_uniqueness_of :location, :scope => [:ware_house_id, :goods_code]

	PICKING_STYLE = %w(single total DAS CART).freeze

	def show_ware_house_name
		self.ware_house.nil? ? '-' : self.ware_house.name
	end

	def sim_qty
		self.qty.to_i + self.allocated_qty.to_i
	end
end
