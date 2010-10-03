class ShippingAddress < ActiveRecord::Base
	has_many :orders
	belongs_to :ware_house

	validates_uniqueness_of :code

	def show_ware_house_name
		self.ware_house.nil? ? '-' : self.ware_house.name
	end
end
