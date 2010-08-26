class EdiFile < ActiveRecord::Base
	EDI_TYPE = [
		%w(出荷指示 shipping),
		%w(出荷実績 shipped),
		%w(入荷予定 receiving),
		%w(入荷実績 received),
		%w(棚卸計画 stock_keeping),
		%w(在庫一覧 inventries)
	]

	def self.status tag
		'Unknown'
	end

	def self.last_edi_status tag
		'Unknown last'
	end

	def self.last_edi_at tag
		'anytime'
	end
end
