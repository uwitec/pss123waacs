class Edi
	require "csv"
	require "fileutils"
	attr_accessor :lines
	
	def initialize
		@lines = []
	end

	def set_order_file
		file = $IMPORT_DIR + '/order-' + Date.today.strftime("%Y%m%d") + '.csv'
		if RAILS_ENV=="development"
			FileUtils.cp RAILS_ROOT + '/test/fixtures/test_order.csv' , file
		end
		file
	end

	def order_file_yml
		RAILS_ROOT + '/config/import_file/edi_order_file.yml'
	end
	
	def receive_order 
		file = set_order_file
		return false unless File.exist?(file)
		ymls = YAML::load_file(order_file_yml)
		tables = %w(shipping_addresses inventories orders)
		tables.each{|table| eval "@#{table} = Array.new; @#{table}_cols = ymls['#{table}']['cols']"}
		line_no = 0
		CSV::open(file,"r").each do |csv|
			line_no += 1
			next if line_no == 1
			tables.each do |table| 
				eval "
					@#{table}.push @#{table}_cols.values.map{|pos| pos == 'all' ? csv.join(',') : csv[pos]}
				"
			end
		end
		tables.each do |table| 
			eval "@#{table}_records = @#{table}.uniq.compact.collect{|r| Hash[*(@#{table}_cols.keys.zip(r).flatten)]}
			"
		end
		#
		@shipping_addresses_records.each do |r|
			shipping_address = ShippingAddress.new(r)
			shipping_address.is_fixed = false
			shipping_address.save
		end	
		#
		#@inventories_records.each do |r|
		#	inventory = Inventory.new(r)
		#	inventory.location = '9999'
		#	inventory.is_fixed = false
		#	inventory.save
		#end
		#
		@orders_records.each do |r|
			unless order = Order.find_by_goods_code_and_order_no(r[:goods_code],r[:order_no])
				order = Order.new(r)
			end
			if order.save
				if shipping_address = ShippingAddress.find_by_code(order.store_code)	
					shipping_address.orders << order
				end
				order.set_ware_house
			end
		end
		# edi_file
		edi_file = EdiFile.new(
			:class_name => 'ordering',
			:edi_code => File.basename(file,'.*'),
			:edi_sub_code => '',
			:file_path => file,
			:pdf_path => '',
			:edi_at => DateTime.now
		)
		edi_file.save 
	end

	def self.set_ware_house
		orders = Order.find(:all, :conditions => "ware_house_id is null")
		orders.each do |order|
			order.set_ware_house
		end
	end
end
