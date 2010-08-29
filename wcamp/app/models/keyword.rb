class Keyword
	KEYS = (
		%w(search)
	).freeze
	
	KEYS.each{|key| eval("attr_accessor :#{key}")}

	def set params
		KEYS.each{|key| eval("@#{key} = params[:#{key}] if params[:#{key}]")}
	end

	def reset
		KEYS.each{|key| eval("@#{key} = ''")}
	end

	def search_receive_conditions
		conditions = []
		unless [nil,''].include?(self.search)
			joined_col_name = 'work_no || goods_code || goods_name || supplier'
			searchs = Array.new
			searchs = self.search.to_s.split(/&/)	
			searchs.each do |word|
				search = Array.new
				search << word.to_s.strip.split(/ /)
				search = (search.delete_if{|w| w.empty?}).map.join("%")
				conditions.push(joined_col_name + " like '%#{search}%'")
			end
		end
		conditions.join(" and ")
	end	
end
