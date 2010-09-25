class WareHouse < ActiveRecord::Base
	has_many :inventries	
	has_many :orders
	has_many :shipping_addresses
	belongs_to :region	

	validates_uniqueness_of :code

	def show_region_name
		self.region.nil? ? '-' : self.region.name
	end
end
