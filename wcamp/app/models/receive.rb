class Receive < ActiveRecord::Base
	require "import_file"
	include ImportFile

	def work_before_import
	end

	def mysort_lines lines
		work_nos = []
		lines.each do |line|
			work_nos.push line.split(',')[0]
		end
		Receive.find(:all, :conditions => {:work_no => work_nos.uniq.compact}).each{|r| r.destroy}
		lines.map{|line| line unless [nil,'','work_no'].include?(line.split(',')[0])}.compact
	end
end
