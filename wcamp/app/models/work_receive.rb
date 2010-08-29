class WorkReceive < ActiveRecord::Base

	def self.active
		work_nos = Receive.find(:all,
			:select => [:work_no],
			:conditions => {:status => [:active, :trouble]},
			:order => "work_no")
		WorkReceive.find(:all, :conditions => {:work_no => work_nos})
	end

	def receives
		Receive.find(:all, :conditions => {:work_no => self.work_no})
	end

	def status
		e = receives.map{|r| r.show_status}
		statuses = e.uniq.map{|x| [x, e.map{|y| y if y == x}.compact.size]}
		statuses.map{|s| s[0] + '(' + s[1].to_s + ')'}.join(" ")	
	end

	def receive_lines
		receives.size
	end
end
