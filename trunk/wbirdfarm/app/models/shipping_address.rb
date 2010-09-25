class ShippingAddress < ActiveRecord::Base
	has_many :orders
	belongs_to :ware_house
end
