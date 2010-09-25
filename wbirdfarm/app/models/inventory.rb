class Inventory < ActiveRecord::Base
	belongs_to :ware_house

	def show_ware_house_name
		self.ware_house.nil? ? '-' : self.ware_house.name
	end
end
