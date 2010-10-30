class EdiFile < ActiveRecord::Base
	belongs_to :ware_house

	EDI_IN_TYPE = [
		%w(受注 ordering),
		%w(出荷実績 shipped),
		%w(入荷実績 received)
	].freeze
		# %w(棚卸実績 stock_keeping_result)

	EDI_OUT_TYPE = [
		%w(出荷指示 shipping),
		%w(入荷予定 receiving)
	].freeze

		# %w(在庫一覧 inventories),
		# %w(棚卸計画 stock_keeping),
	def self.show_status tag
		edi_file = EdiFile.first(:conditions => {:class_name => tag}, :order => "edi_at desc")
		edi_file ? edi_file.status : nil 
	end

	def self.lines tag
		[]
	end

	def self.last_edi_at tag
		edi_file = EdiFile.first(:conditions => {:class_name => tag}, :order => "edi_at desc")
		edi_file ? edi_file.edi_at : nil 
	end

	# EDI
	def self.ordering
		Edi.new.receive_order
	end
	
	def self.shipping
		PickingPlan.new.allocate_total
		PickingPlan.new.allocate_single
	end

	def show_class_name
		(EDI_OUT_TYPE + EDI_IN_TYPE).rassoc(self.class_name.split('/')[0])[0] rescue '-'
	end

	def show_sub_class_name
		case self.class_name
		when 'shipping'
			(PickingPlan::LIST_TYPE).rassoc(self.edi_sub_code)[0] rescue '-'
		else
			self.edi_sub_code
		end
	end
end
