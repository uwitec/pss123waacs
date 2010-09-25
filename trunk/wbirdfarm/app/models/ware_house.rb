class WareHouse < ActiveRecord::Base
	has_many :inventries	
	has_many :orders
	has_many :shipping_addresses
	belongs_to :region	
end
