class Report::FeedingList < JpReport
	#  0              1(1)        2(2)        3(4)      4(5)
	# [customer_code, store_code, goods_code, pick_qty, order.id]
	require 'nkf'
	attr_accessor :picks

	def initialize
		options = {
			:language => 'japanese',
			:size => 10,
			:file => 'feed_list'
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
		last_work_no = ''
		@picks.each do | p |
			unless ['',p[5]].include?(last_work_no)
				tline(:body)
				self.AddPage
				line_no = 1
			end
			if line_no == 1
				#rect_main
				set_start_on :head
				wls('配送先別出荷指示(一括出荷分)' ,:L, :head);bLF
				wla('顧客:' + p[0], 10, :L, :head);bLF
				wla('店舗:' + p[1], 10, :L, :head);bLF

				set_start_on :body
				#  0              1(1)        2(2)        3(4)      4(5)      5
				# [customer_code, store_code, goods_code, pick_qty, order.id, work_no]
				tline(:body)
				wla('出荷管理番号',    0, :L, :body)
				wla('顧客コード',     30, :L, :body)
				wla('店舗コード',     60, :L, :body)
				wla('商品コード',     90, :L, :body)
				wla('指示数',        150, :L, :body)
				bLF
				tline(:body)
			end
			wla(p[5],   0, :L, :body)
			wla(p[0],  30, :L, :body)
			wla(p[1],  60, :L, :body)
			wla(p[2],  90, :L, :body)
			wla(p[3], 150, :R, :body)
			bLF
			line_no += 1
			last_work_no = p[5]
		end
		tline(:body)
	end
end
