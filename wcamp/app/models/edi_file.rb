class EdiFile < ActiveRecord::Base
	# [name , TAG ]
	EDI_TYPE = [
		%w(出荷指示 shipping),
		%w(出荷実績 shipped),
		%w(入荷予定 receiving),
		%w(入荷実績 received),
		%w(棚卸計画 stock_keeping),
		%w(在庫一覧 inventories)
	].freeze
	
	# class_name => [class status ... ]
	TAG_CLASS = {
		"shipping" => ['ShipOrder','','10','20','30','40','50','',nil],
		"shipped" => %w(ShipOrder 50 90),
		"receiving" => ['Receive','','10','20','30','40','50','',nil],
		"received" => %w(Receive 50 90),
		"stock_keeping" => %w(StockKeeping),
		"inventories" => %w(Inventory)
	}.freeze
	
	def self.lines tag
		tags = TAG_CLASS[tag]
		class_name = tags[0]	
		begin
			if tags[1,tags.size].size > 0
				eval("#{class_name}.find(:all, :conditions => {:status => tags})")
			else
				eval("#{class_name}.find(:all)")
			end
		rescue
			[]
		end
	end

	def self.show_status tag
		e = EdiFile.lines(tag).map{|r| r.show_status}
		statuses = e.uniq.map{|x| [x, e.map{|y| y if y == x}.compact.size]}
		statuses.map{|s| s[0] + '(' + s[1].to_s + ')'}.join(" ")	
	end

	def self.last_edi_at tag
		EdiFile.maximum("edi_at", :conditions => {:class_name => tag})
	end
	
	def show_class_name
		(r = EDI_TYPE.rassoc(self.class_name)) ? r[0] : '不明'
	end

	def status
		'-'
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

	def self.shipped
		tag = "shipped"
		export_file = $EXPORT_DIR + '/' + $WareHouseCode + "-" + tag + "-" + DateTime.now.strftime("%Y%m%d%H%M%S") + ".csv"
		upload_file = $EXPORT_DIR + '/' + $WareHouseCode + "-" + tag + ".csv"
		ships = ShipOrder.find(:all, 
			:conditions => {:status => '50'}, :order => 'work_no, work_line_no')
		if ShipOrder.new.export_file export_file, ships, 'ship_order.yml'	
			ships.each{|s| s.status = '90'; s.save}
			ShipOrder.new.export_file upload_file, ships, 'ship_order.yml', false
		end
	end

	def self.received
		export_file = $EXPORT_DIR + '/' + 'receive.dat'
		receives = Receive.find(:all, 
			:conditions => {:status => '50'}, :order => 'work_no,goods_code')
		if Receive.new.export_file export_file, receives, 'receive.yml'	
			receives.each do |r|
				r.status = '90'
				r.save
				if r.announced_qty > r.result_qty
					receive = Receive.new(r.attributes)
					receive.announced_qty = r.announced_qty - r.result_qty
					receive.status = '10'
					receive.result_qty = 0	
					receive.user_code = ''
					receive.quality_status = ''
					receive.lot_no = ''
					receive.expire_on = ''
					receive.save
				end
			end
		end
	end

	def self.stock_keeping
	end

	def self.inventries
	end
	
end
