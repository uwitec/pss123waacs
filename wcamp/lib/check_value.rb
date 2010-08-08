module CheckValue
	require "date"

	def to_i str
		str.to_i
	end

	def to_f str
		str.to_f
	end
	
	def to_date str = ""
		date_string?(str) ? Date.parse(str) : ""
	end

	def to_datetime str = ""
		datetime_string?(str) ? DateTime.parse(str) : ""
	end
	
	def show_date date
		begin
			date.strftime("%Y-%m-%d")
		rescue
			""
		end
	end

	def show_date_dmy date
		begin
			date.strftime("%d/%m/%Y")
		rescue
			""
		end
	end
	
	def to_fix_value a
		a
	end

	def date_string? str
		begin
			Date.parse(str)
			true
   	rescue
			false
		end
	end

	def datetime_string? str
		begin
			DateTime.parse(str)
			true
   	rescue
			false
		end
	end

	def integer_string? str
		begin
			Integer(str)
			true
		rescue ArgumentError
			false
		end
	end

	def float_string? str
		begin
			Float(str)
			true
		rescue ArgumentError
			false
		end
	end		
end
