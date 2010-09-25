class Order < ActiveRecord::Base
	belongs_to :ware_house
	belongs_to :shipping_address
end
