class WareHouse < ActiveRecord::Base
	has_many :inventories	
	has_many :orders
	has_many :shipping_addresses
	has_many :casein_users
	has_many :edi_files
	belongs_to :region	

	validates_uniqueness_of :code

	def show_region_name
		self.region.nil? ? '-' : self.region.name
	end
end
