class JpReport < FPDF
	require 'nkf'
	attr_accessor :filename, :language, :blocks, :styles, :tables, :lasth
	LANG_NAMES = ['japanese','chinese'].freeze

	def initialize(options = {})
		type = (options[:type] || 'P')    # P: Portrait, L: Landscape
		unit = 'mm'                       # in(ch),mm,cm,pt --> mm fix
		paper = (options[:paper] || 'a4') # A4, A3, letter, legal 
		super(type,unit,paper)
		page_config(options)
	end
	
	#automatically do after "AddPage"
	def Header
		if @page == 1
			first_page_header
		else
			page_header	
		end
	end
	
	def Footer
	end

	#overwrite
	def first_page_header
	end 
	
	#overwrite
	def page_header
	end

	#overwrite
	def contents
	end

	# mypdf methods 
	# -----------------------------------------------------------------
	def page_config(options = {})
		#options
		#type = (options[:type] || 'P')    # P: Portrait, L: Landscape
		#unit = 'mm'   # in(ch),mm,cm,pt --> mm fix
		#paper = (options[:paper] || 'A4') # A4, A3, letter, legal 
		
		size = (options[:size] || 10)
		@language = (LANG_NAMES.include?(options[:language]) ? options[:language] : 'english')
		@filename = (options[:file] || 'pdf_page.pdf')
		
		@l_h = (options[:line_height] || 4)
		
		lMargin = (options[:lMargin] || 15) 
		rMargin = (options[:rMargin] || 10) 
		tMargin = (options[:tMargin] || 10) 
		bMargin = (options[:bMargin] || 10) 
			
		@blocks = {}
		@styles = {}
		@tables = {}
		SetMargins(lMargin,tMargin,rMargin)
		@bMargin = bMargin
		
		set_layout(@language,size)
		set_block_main()
		set_style_common(size)
	end

	def get_layout_info
		[@w,@h,@lMargin,@rMargin,@tMargin,@bMargin]
	end


	def set_layout(lang = "english",size = 12)
		case lang
		when 'japanese'
			extend(PDF_Japanese)
			AddSJISFont()
			SetFont('SJIS','',size)
		when 'japanese_gothic'
			extend(PDF_Japanese)
			AddSJISFont()
			AddSJISFontGothic()
			SetFont('SJISG','',size)
		when 'chinese'
			extend(PDF_Chinese)
			AddBig5Font()
			SetFont('Big5','',size)
		else 
			SetFont('Arial','',size)
		end
		#AddPage()
	end

	def print_by_style(value,style = {})
		begin
			value = sprintf(style[:format],value)	if style[:format] 
			w = (style[:wide] || 0)
			h = (style[:height] || common_style[:height])
			a = (style[:align] || 'L')
			border = (style[:border] || 0)
			line_size = (style[:line_size] || 0.1)
			SetLineWidth(line_size)
			Cell(w,h,value,border,0,a)
		rescue
			$stderr.print value
			$stderr.print $!
		end
		value
	end
	
	def set_line_height height
		@l_h = height
	end

	def set_block_main
		(pw,ph,ml,mt,mr,mb) = get_layout_info
		set_block('main',[0,0,pw-ml-mr,ph-mt-mb])
	end

	# define block (x,y,w,h)
	def set_block(bname,block = [0,0,0,0])
		(pw,ph,ml,mt,mr,mb) = get_layout_info
		if block.is_a?(Array) and block.size == 4
			@blocks[bname] = [block[0] + ml,block[1] + mt, block[2], block[3]]
		end
	end

	def set_style(name,options = {})
		@styles[name] = {}
		@styles[name][:wide] = (options[:wide] || common_style[:wide]) 
		@styles[name][:height] = (options[:height] || common_style[:height]) 			
		@styles[name][:align] = (options[:align] || common_style[:align])			
		@styles[name][:format] = (options[:format] || common_style[:format]) 			
		@styles[name][:size] = (options[:size] || common_style[:size])
	end

	def set_style_common(size = 10)
		(pw,ph,ml,mt,mr,mb) = get_layout_info
		set_style('common',{:wide => (pw-ml-mr),:height => (size/2),:align => 'L',:format => '%s',:size => size })
	end

	def common_style() @styles['common']; end
	def main_block() @blocks['main']; end

	def get_xy(my_x,my_y,block = 'main')
		(x0,y0,w0,h0) = (@blocks[block] || main_block)
		x = x0 + my_x + ( my_x<0 ? w0 : 0 )
		y = y0 + my_y + ( my_y<0 ? h0 : 0 )
		[x,y]
	end	

	def write_data(value, x=0, y=0)	
		value = NKF::nkf("-s",value) if @language == 'japanese'
		Text(x,y, value)
	end
	alias wd write_data

	def write_with_style(value,x=0,y=0,style='common',block='main')
		value = NKF::nkf("-s",value.to_s) if @language == 'japanese'
		
		style_h = {}
		if !style.is_a?(Hash) or style == nil
			style_h = (@styles.keys.index(style) ? @styles[style] : common_style)
		end
		style_h = common_style.merge(style) if style.is_a?(Hash)
		SetFontSize(style_h[:size])
		(x,y) = get_xy(x,y,block)
		SetXY(x,y)
		print_by_style(value,style_h)
	end
	alias wws write_with_style

	def set_start_on block='main' 
		(x,y) = get_xy(0,0,block)
		SetXY(x,y)
	end
	
	def bLF block = 'main'
		(x0,y0,w0,h0) = (@blocks[block] || main_block)
		SetX(x0)
		self.Ln
	end

	def write_line_with_style(value, style='common', block='main')
		(x0,y0,w0,h0) = (@blocks[block] || main_block)
		write_with_style(add_slash(value),0,@y - y0,style,block)
	end
	alias wls write_line_with_style
	
	def write_add_line_with_style(value, add_size, style='common', block='main')
		(x0,y0,w0,h0) = (@blocks[block] || main_block)
		write_with_style(add_slash(value),add_size,@y - y0,style,block)
	end
	alias wla write_add_line_with_style

	#horizontal line
	def hline(x,y,w,block = 'main',width=0.1)
		SetLineWidth(width)
		(x,y) = get_xy(x,y,block)
		Line(x,y,x+w,y)
	end

	def vline(x,y,h,block = 'main',width=0.1)
		SetLineWidth(width)
		(x,y) = get_xy(x,y,block)
		Line(x,y,x,y+h)
	end

	def line(x,y,x1,y1,width=0.1)
		SetLineWidth(width)
		(pw,ph,ml,mr,mt,mb) = get_layout_info
		Line(x+ml,y+mt,x1+ml,y1+mt)
	end

	def rect(x,y,w,h,block = 'main',width=0.1)
		SetLineWidth(width)
		(x,y) = get_xy(x,y,block)
		Rect(x,y,w,h)
	end

	def topline(block = 'main', wide = 0.1)
		(x0,y0,w0,h0) = (@blocks[block] || main_block)
		hline(1,@y - y0,w0 - 2,block,wide)
	end
	alias tline topline
	
	def topline_a(x1, w1, block = 'main', wide = 0.1)
		(x0,y0,w0,h0) = (@blocks[block] || main_block)
		hline(x1,@y - y0,w1 ,block,wide)
	end
	alias tline_a topline_a

	def rect_main(width=0.1)
		(pw,ph,ml,mr,mt,mb) = get_layout_info
		SetLineWidth(width)
		Rect(ml,mt,pw - ml - mr,ph - mt - mb)
	end

	def rect_block(block_name,width=0.1)
		(x0,y0,w0,h0) = (@blocks[block_name] || main_block)
		SetLineWidth(width)
		Rect(x0,y0,w0,h0)
	end

	def page_out
		File.open(@filename,'wb'){|f| f.write(Output)}
	end

	def page_output
		Output
	end

	def money_format(num)
  	return (num.to_s =~ /[-+]?\d{4,}/) ? (num.to_s.reverse.gsub(/\G((?:\d+\.)?\d{3})(?=\d)/, '\1,').reverse) : num.to_s
	end

	def add_slash value
		value.to_s.gsub('ソ','ソ\\')	
	end	
end
