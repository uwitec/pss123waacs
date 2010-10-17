class Inventory < ActiveRecord::Base
	belongs_to :ware_house
	
	validates_uniqueness_of :location, :scope => [:ware_house_id, :goods_code]

	PICKING_STYLE = %w(single total DAS CART).freeze
	FIXED_TYPE = %w(確定 未決).freeze

	def self.myhouse user
		if user.is_admin?
			Inventory.all
		else
			Inventory.ware_house_id_equals(user.ware_house_id)
		end
	end

	def show_ware_house_name
		self.ware_house.nil? ? '-' : self.ware_house.name
	end

	def show_is_fixed
		self.is_fixed ? FIXED_TYPE[0] : FIXED_TYPE[1]
	end	

	def sim_qty
		self.qty.to_i + self.allocated_qty.to_i
	end
end
