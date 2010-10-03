class Order < ActiveRecord::Base
	belongs_to :ware_house
	belongs_to :shipping_address

	validates_uniqueness_of :goods_code, :scope => [:order_no]
end
