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
		receives.map{|r| r.status}.uniq.compact.join(" ")
	end

	def receive_lines
		receives.size
	end
end
