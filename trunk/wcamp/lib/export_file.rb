module ExportFile
	require "csv"
	require "check_value"
	include CheckValue
	
	def export_config_file_name
		RAILS_ROOT + "/config/export_file/" + self.class.to_s.underscore + ".yml"
	end
	
	def exchange_config_file_name
		RAILS_ROOT + "/config/export_file/" + self.class.to_s.underscore + ".yml"
	end
	
	def work_before_exoprt file = nil
	end

	def work_after_export
	end

	def export_mysort_lines lines = []
		lines
	end

	def export_file file , records, config_file = nil
		export_file_name = file
		config_file_name = export_config_file_name
		if config_file
			config_file_name = RAILS_ROOT + "/config/export_file/" + config_file
		end
		config = YAML.load_file(config_file_name) || {}
		format = config["format"] || {}
		total_size = (config["common"]["total_size"]).to_i
		check_integer_position = config["common"]["check_integer_position"] 
		file_type = (config["common"]["file_type"] || "csv")
		
		if file_type == "csv"
			CSV.open(export_file_name , "w"){ |csv|
				index_sorted_name = []
				format.each do |col_name, detail| 
					index_sorted_name.push [detail["start"], col_name, detail["view"], detail["action"]]
				end	
				index_sorted_name = index_sorted_name.sort
				csv << index_sorted_name.map{|i| ([nil,''].include?(i[2]) ? i[1] : i[2]) }
				records.each do |r|
					csv_line = []
					index_sorted_name.each do |index, name, view_name, col_action|	
						v = r.__send__(name)
						if col_action
							if /%%/ === col_action 
								v = eval("#{col_action.gsub(/%%/,v.to_s)}")
							else
								v = eval("#{col_action} v") 
							end
						end
						csv_line.push(v)
					end
					csv << csv_line
				end
			}
		else
			File.open(export_file_name , "w"){ |f|
				records.each do |r|
					line = "\s" * total_size
					format.each do |col_name,detail|
						v = r.__send__(col_name)
						col_size = detail["size"].to_s.to_i
						col_start = detail["start"].to_s.to_i
						col_action = detail["action"]
						col_format = detail["format"] 
						
						v = eval("#{col_action} v") if col_action
						if col_format && col_format.include?('r')
							v = v.to_s.strip.rjust(col_size, "\s")[-1 * col_size , col_size]
						else
							v = v.to_s.ljust(col_size, "\s")[0, col_size]
						end	
						line[ col_start - 1, col_size ] = v
					end	
					f.write line + "\n"
				end
			}		
		end
	end

	def exchange_fix_to_csv  fix_file, csv_file
		config = YAML.load_file(exchange_config_file_name) || {}
		format = config["format"] || {}
		total_size = (config["common"]["total_size"]).to_i
		check_integer_position = config["common"]["check_integer_position"] 
		file_type = (config["common"]["file_type"] || "csv")
		return false unless file_type == "csv"	
		return false unless File.exist?(fix_file)	
		
		index_sorted_name = []
		format.each do |col_name, detail| 
			index_sorted_name.push [detail["start"],detail["size"], detail["action"], col_name]
		end	
		index_sorted_name = index_sorted_name.sort
		CSV.open(csv_file , "w") do |csv|
			csv << index_sorted_name.map{|i| i[3]}
			lines = File.readlines(fix_file)
			lines = export_mysort_lines(lines)
			lines.each do |line|
				csv_line = []
				index_sorted_name.each do |d|
					(col_start, col_size, col_action, col_name) = d
					csv_line.push(line[col_start - 1, col_size].to_s.strip)
				end
				csv << csv_line
			end
		end	
	end

	# helper
	def make_export_template filename = nil
		escape = %w(created_at updated_at created_on updated_on id)
		unless filename
			filename = self.class.to_s.underscore
		end
		yml_file = RAILS_ROOT + '/config/export_file/' + filename + '.yml'
		File.open(yml_file, 'w') do |f|
			f.write <<_END1
common :
  name : #{filename}
  total_size :
  check_integer_position :
  file_type : csv
format :
_END1
			columns = self.class.columns.map{|a| a.name unless escape.include?(a.name)}.uniq.compact
			columns.each do |col|
				f.write <<_END2
  #{col} :
    start  :
    size   :
    view   :
    action :
_END2
			end
		end
	end
end
