class Order < ActiveRecord::Base
	belongs_to :ware_house
	belongs_to :shipping_address

	validates_uniqueness_of :goods_code, :scope => [:order_no]

	def show_ware_house_name
		self.ware_house.nil? ? '-' : self.ware_house.name
	end

	def set_ware_house
		shipping_address = (self.shipping_address || ShippingAddress.find_by_code(self.store_code))
		if shipping_address
			shipping_address.ware_house.orders << self
		end
	end
end
