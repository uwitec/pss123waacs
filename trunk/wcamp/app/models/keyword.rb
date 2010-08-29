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
		conditions.push("status not in('50','90')") if [nil,'',0,'0'].include?(self.show_fixed)
		conditions.join(" and ")
	end	

	def search_shipping_conditions
		conditions = []
		conditions.push("work_no = '#{self.work_no}'") unless [nil,''].include?(self.work_no)
		conditions.push("status not in('50','90')") if [nil,'',0,'0'].include?(self.show_fixed)
		conditions.join(" and ")
	end
end
