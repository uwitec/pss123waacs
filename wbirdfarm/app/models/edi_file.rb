class EdiFile < ActiveRecord::Base
	EDI_TYPE = [
		%w(受注 ordering),
		%w(出荷指示 shipping),
		%w(出荷実績 shipped),
		%w(入荷予定 receiving),
		%w(入荷実績 received),
		%w(棚卸計画 stock_keeping),
		%w(在庫一覧 inventories)
	].freeze

	def self.show_status tag
		'-'
	end

	def self.lines tag
		[]
	end

	def self.last_edi_at tag
		nil
	end

	# EDI
	def self.ordering
		Edi.new.receive_order
	end
	
	def self.shipping
		PickingPlan.allocate_total
		PickingPlan.allocate_single
	end
end
