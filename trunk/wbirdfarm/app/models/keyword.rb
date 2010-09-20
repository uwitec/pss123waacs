class Keyword
	KEYS = (
		%w(search show_fixed work_no)
	).freeze
	
	KEYS.each{|key| eval("attr_accessor :#{key}")}

	def set params
		KEYS.each{|key| eval("@#{key} = params[:#{key}] if params[:#{key}]")}
	end

	def reset
		KEYS.each{|key| eval("@#{key} = ''")}
	end

end
