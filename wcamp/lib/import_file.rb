module ImportFile
	require 'csv'
	require 'kconv'
	require 'check_value'
	include CheckValue
	
	def config_file_name
		RAILS_ROOT + "/config/import_file/" + self.class.to_s.underscore + ".yml"
	end

	def work_before_import
	end

	def import_file file
		return false unless FileTest.exist? file
		import_file_name = $IMPORT_DIR + '/' + File.basename(file) + '.' + DateTime.now.strftime('%y%m%d%H%M')
		backup_file_name = $BACKUP_DIR + '/' + File.basename(file) + '.bak'
		
		FileUtils.mv(file,import_file_name)
		work_before_import
		if load_file(import_file_name)
			FileUtils.mv(import_file_name, backup_file_name)
		end
	end

	def mysort_lines lines = []
		lines
	end

	def load_file file
		lines = []
		lines = File.readlines(file).map{|l| l.chomp}
	
		lines = mysort_lines(lines)
		config = YAML.load_file(config_file_name) || {}
		@format = config["format"] || {}
		total_size = config["common"]["total_size"]
		check_integer_position = config["common"]["check_integer_position"] 
		file_type = (config["common"]["file_type"] || "csv")
		
		count = 0
		lines.each do |line|
			if file_type == "csv"
				count += 1 if parse_csv_line(line, total_size, check_integer_position)
			elsif file_type == "fix"
				count += 1 if parse_fix_line(line, total_size, check_integer_position)
			end
		end
		count
	end

	def parse_csv_line csv_line,total_size = nil,check_integer_position = nil 
		line = CSV.parse(csv_line).shift
		if total_size
			return false unless total_size <= line.size
		end
		if check_integer_position
			return false if [nil,""].include?(line[check_integer_position.to_i - 1])
			return false unless integer_string?(line[check_integer_position.to_i - 1])
		end
		line = line.map{|n| n.to_s.strip}
		column_and_value = []
		column_and_value = @format.map{|c,d|
			v = line[d["index"]-1] || ""
			if d["action"] and d["action"] != nil
				col_action = d["action"]
				if /%%/ === col_action	
					v = eval(col_action.gsub('%%',v))
				else
					v = eval("#{col_action} v")
				end
			end
			v = d["value"] if d["value"]
			[c,v]
		}
		import_line(column_and_value)
	end

	def parse_fix_line line,total_size = nil,check_integer_position = nil
		unless [nil,"",0].include? total_size
			return false if total_size >= line.size
		end
		unless [nil,"",0].include? check_integer_position
			return false unless integer_string? line[check_integer_position.to_i - 1,1]
		end
		column_and_value = []
		column_and_value = @format.map{|c,d|
			v = (line[d["start"]-1,d["size"]].strip rescue "t")
			if d["action"] and d["action"] != nil
				col_action = d["action"]
				if /%%/ === col_action	
					v = eval(col_action.gsub('%%',v))
				else
					v = eval("#{col_action} v")
				end
			end
			v = d["value"] if d["value"]
			[c,v]
		}
		import_line(column_and_value)
	end

	def import_line column_and_value
		target = self.class.new
		column_and_value.each{ |col,value| target[col.to_sym] = value }
		unless target.save
			$stderr.print(target.errors.full_messages.join("\n") + "\n")
		end
	end

	# helper
	def make_import_template
		escape = %w(created_at updated_at created_on updated_on id)
		yml_file = RAILS_ROOT + '/config/import_file/' + self.class.to_s.underscore + '.yml'
		File.open(yml_file, 'w') do |f|
			f.write <<_END1
common :
  name : #{self.class.to_s.underscore}
  total_size :
  check_integer_position :
  file_type : fix
format :
_END1
			columns = self.class.columns.map{|a| a.name unless escape.include?(a.name)}.uniq.compact
			columns.each do |a|
				f.write <<_END2
  #{a} :
    start  :
    size   :
    action :
_END2
			end
		end
	end
	
	def make_import_template_for_csv
		escape = %w(created_at updated_at created_on updated_on id)
		yml_file = RAILS_ROOT + '/config/import_file/' + self.class.to_s.underscore + '.yml'
		File.open(yml_file, 'w') do |f|
			f.write <<_END1
common :
  name : #{self.class.to_s.underscore}
  total_size :
  check_integer_position :
  file_type : csv
format :
_END1
			columns = self.class.columns.map{|a| a.name unless escape.include?(a.name)}.uniq.compact
			n = 0
			columns.each do |a|
				n += 1
				f.write <<_END2
  #{a} :
    index  : #{n}
    value  :
    action :
_END2
			end
		end
	end
end
