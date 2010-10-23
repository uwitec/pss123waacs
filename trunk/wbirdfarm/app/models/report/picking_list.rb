class Report::PickingList < JpReport
	require 'nkf'
	attr_accessor :picks

	def initialize
		options = {
			:language => 'japanese',
			:size => 10,
			:file => 'picking_list'
		}
		super(options)
	end

	def contents
		set_style :L, {:align => 'L'}
		set_style :R, {:align => 'R',:wide => 20}
		set_style :Lsmall, {:align => 'L',:size => 8}

		rect_main
		set_start_on
		wla('出荷明細');bLF

		@picks.each do |p|
			wls(p.join("\s"), :L );bLF	
		end
	end
end
