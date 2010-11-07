class Report::TotalPickingList < JpReport
	# cf) total_picking_list format
	#  0              1(2)        2(3)      3(4)      4(6)
	# [customer_code, goods_code, location, pick_qty, inventory.id]
	TotalPickingListCol = %w(customer_code goods_code location pick_qty inventory.id).freeze

	require 'nkf'
	attr_accessor :picks

	def initialize
		options = {
			:language => 'japanese',
			:size => 10,
			:file => 'total_picking_list'
		}
		super(options)
	end

	def contents
		set_style :L, {:align => 'L'}
		set_style :R, {:align => 'R',:wide => 20}
		set_style :Lsmall, {:align => 'L',:size => 8}

		set_block :head, [0, 10, 185, 30]
		set_block :body, [0, 40, 185, 270]

		#
		@picks.shift
		line_no = 1
		last_customer_code = ''
		@picks.each do | p |
			unless ['',p[0]].include?(last_customer_code)
				tline(:body)
				self.AddPage
				line_no = 1
			end
			if line_no == 1
				#rect_main
				set_start_on :head
				wls('一括出荷指示', :L, :head);bLF
				wla('顧客:' + p[0], 10, :L, :head);bLF

				set_start_on :body
				#  0              1(2)        2(3)      3(4)      4(6)
				# [customer_code, goods_code, location, pick_qty, inventory.id]
				tline(:body)
				wla('顧客コード',      0, :L, :body)
				wla('商品コード',     30, :L, :body)
				wla('ロケーション',  120, :L, :body)
				wla('指示数',        150, :L, :body)
				bLF
				tline(:body)
			end
			wla(p[0],   0, :L, :body)
			wla(p[1],  30, :L, :body)
			wla(p[2], 120, :L, :body)
			wla(p[3], 150, :L, :body)
			bLF
			line_no += 1
			last_customer_code = p[0]
		end
		tline(:body)
	end
end
