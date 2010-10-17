class Keyword
	KEYS = (
		%w(search show_fixed work_no ware_house)
	).freeze
	
	KEYS.each{|key| eval("attr_accessor :#{key}")}

	def set params
		KEYS.each{|key| eval("@#{key} = params[:#{key}] if params[:#{key}]")}
	end

	def reset
		KEYS.each{|key| eval("@#{key} = ''")}
	end

end
