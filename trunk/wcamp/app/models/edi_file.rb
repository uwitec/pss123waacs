class EdiFile < ActiveRecord::Base
	EDI_TYPE = [
		%w(出荷指示 shipping),
		%w(出荷実績 shipped),
		%w(入荷予定 receiving),
		%w(入荷実績 received),
		%w(棚卸計画 stock_keeping),
		%w(在庫一覧 inventries)
	].freeze

	def self.status tag
		'Unknown'
	end

	def self.last_edi_status tag
		'Unknown last'
	end

	def self.last_edi_at tag
		'anytime'
	end

	def self.shipping
		import_file = $IMPORT_DIR + '/' + 'ship_orders.csv'
		if RAILS_ENV == 'development'
			FileUtils.cp RAILS_ROOT + '/test/fixtures/' + 'ship_orders.csv', import_file
		end
		ShipOrder.new.import_file(import_file)	
	end

	def self.receiving
		import_file = $IMPORT_DIR + '/' + 'receives.csv'
		if RAILS_ENV == 'development'
			FileUtils.cp RAILS_ROOT + '/test/fixtures/' + 'receives.csv', import_file
		end
		Receive.new.import_file(import_file)
	end

	def show_class_name
		(r = EDI_TYPE.rassoc(self.class_name)) ? r[0] : '不明'
	end

	def status
		'-'
	end
end
