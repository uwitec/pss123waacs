class PickingPlan #< ActiveRecord::Base
	require "csv"
	# cf) picking_list format
	#  0              1           2           3         4         5         6
	# [customer_code, store_code, goods_code, location, pick_qty, order.id, inventory.id]
	#
	# cf) total_picking_list format
	#  0              1(2)        2(3)      3(4)      4(6)
	# [customer_code, goods_code, location, pick_qty, inventory.id]
	#
	# cf) feeding_list format
	#  0              1(1)        2(2)        3(4)      4(5)
	# [customer_code, store_code, goods_code, pick_qty, order.id]
	
	PickingListCol = %w(customer_code store_code goods_code location pick_qty order.id inventory.id work_no).freeze
	TotalPickingListCol = %w(customer_code goods_code location pick_qty inventory.id).freeze
	FeedingListCol = %w(customer_code store_code goods_code pick_qty order.id work_no).freeze

	LIST_TYPE = [
		%w(商品別(一括) total),
		%w(店舗別 single),
		%w(店舗別(一括) feeding),
		%w(DAS das),
		%w(カート cart)
	].freeze
	
	attr_accessor :issued_at, :tag, :report_type

	def initialize tag = ''
		@tag = tag
		@report_type = ''
		@issued_at = DateTime.now
	end

	# total picking order allocation
	def allocate_total
		orders = Order.not_allocated.picking('total')
		return false if orders.size == 0
		pickings = self.allocate(orders)
		# total_picking_list
		total_pickings = {}
		pickings.each do |p|
			if total_pickings[p.values_at(0,2,3,4,6)] 			
				total_pickings[p.values_at(0,2,3,4,6)][3] += p[4]
			else
				total_pickings[p.values_at(0,2,3,4,6)] = p.values_at(0,2,3,4,6) 			
			end
		end
		self.report_type = 'total'
		self.show_picking_list(total_pickings.values.sort{|a,b| a.values_at(0,1,2,3) <=> b.values_at(0,1,2,3)})

		# feeding_list
		feedings = {}
		pickings.each do |p|
			if feedings[p.values_at(0,1,2,4,5)] 			
				feedings[p.values_at(0,1,2,4,5)][3] += p[4]
			else
				feedings[p.values_at(0,1,2,4,5)] = p.values_at(0,1,2,4,5) 			
			end
		end
		#work No set
		last_work_no = '';last_customer_code = ''; last_store_code = ''
		feedings.values.sort{|a,b| a.values_at(0,1) <=> b.values_at(0,1)}.each do |pi|
			unless (pi[0] == last_customer_code and pi[1] == last_store_code)
				last_work_no = NumberMaster.new_picking_work_no	
				last_customer_code = pi[0]
				last_store_code = pi[1]
			end
			pi.push last_work_no
		end
		self.report_type = 'feeding'
		self.show_picking_list(feedings.values.sort{|a,b| a.values_at(0,1) <=> b.values_at(0,1)})
	end

	# single picking order allocation
	def allocate_single
		# todo sort or weight 
		orders = Order.not_allocated.picking('single')
		return false if orders.size == 0
		picking_list = self.allocate(orders)
		#work No set
		last_work_no = '';last_customer_code = ''
		picking_list.sort{|a,b| a.values_at(0,1,3) <=> b.values_at(0,1,3)}.each do |pi|
			unless pi[0] == last_customer_code
				last_work_no = NumberMaster.new_picking_work_no	 
				last_customer_code = pi[0]
			end
			pi.push last_work_no
		end
		self.report_type = 'single'
		self.show_picking_list(picking_list.sort{|a,b| a.values_at(0,1,3) <=> b.values_at(0,1,3)})
	end

	def allocate orders	
		picking_list = []
		orders.each do |order|
			balance_qty = order.order_qty
			inventories = Inventory.find(:all, :conditions => {:goods_code => order.goods_code})
			inventories.each do |inventory|
				next if inventory.sim_qty <= 0
				sim_qty = inventory.sim_qty
				sim_qty >= balance_qty ?  pick_qty = balance_qty : pick_qty = sim_qty
				picking_list.push [order.customer_code, order.store_code, order.goods_code, inventory.location, pick_qty, order.id, inventory.id]
				inventory.allocated_qty = inventory.allocated_qty.to_i - pick_qty
				inventory.save
				balance_qty -= pick_qty
				break if balance_qty <= 0
			end
			order.allocate_status = 'fix'
			if balance_qty > 0
				order.allocate_status = 'stockout'
				picking_list.push [order.customer_code, order.store_code, order.goods_code, 'ZZZ', balance_qty, order.id, 0] 
			end
			order.save
		end	
		picking_list
	end

	def self.allocated_clear
		inventories = Inventory.all(:conditions => "allocated_qty is not null or allocated_qty = 0")
		Inventory.find(:all).each{|inv| inv.allocated_qty = 0;inv.save}
		orders = Order.all(:conditions => {:allocate_status => ['fix', 'stockout']})
		orders.each{|order| order.allocate_status = '';order.save}
	end

	def show_picking_list report = []
		file_name = $EXPORT_DIR + '/' + picking_list_file_name + '.csv'
		pdf_name = $EXPORT_DIR + '/' + picking_list_file_name + '.pdf'
		data = []
		case @report_type
		when 'total'
			data << TotalPickingListCol
			make_ship_order_file file_name, TotalPickingListCol, report
			pdf = Report::TotalPickingList.new
		when 'single'
			data << PickingListCol
			make_ship_order_file file_name, PickingListCol, report
			pdf = Report::PickingList.new
		when 'feeding'
			data << FeedingListCol
			make_ship_order_file file_name, FeedingListCol, report
			pdf = Report::FeedingList.new
		else
			data << PickingListCol
			make_ship_order_file file_name, PickingListCol, report
			pdf = Report::PickingList.new
		end
		data += report
		# csv file
		# CSV.open(file_name, "w"){ |csv| data.each{|item| csv << item} }
		# pdf file
		pdf.picks = data
		pdf.AddPage
		pdf.contents
   	pdf.Output(pdf_name)
		#
		edi_file = EdiFile.new(
			:class_name => 'shipping',
			:edi_code => self.picking_list_file_name,
			:edi_sub_code => @report_type, 
			:file_path => file_name,
			:pdf_path => pdf_name,
			:edi_at => @issued_at
		)
		edi_file.save
	end
	
	def make_ship_order_file file_path, col_keys, report = []
		cols = YAML.load_file(RAILS_ROOT + '/config/export_file/ship_order.yml')['format']
		keys = cols.sort{|a,b| a[1]['index'] <=> b[1]['index']}.map{|x| x[0]}
		
		CSV.open(file_path,"w") do |csv|
			report.each do |d|
				data_set = col_keys.zip(d)
				new_data = []
				keys.each do |key|
					val = (begin data_set.assoc(key)[1] rescue "" end)	
					new_data.push val
				end
				csv << new_data
			end
		end
	end

	def picking_list_file_name
		'PL' + @tag.upcase + @report_type.upcase + @issued_at.strftime('%Y%m%d')
	end
end
