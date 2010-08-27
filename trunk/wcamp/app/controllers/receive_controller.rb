class ReceiveController < CaseinController # ApplicationController
	layout 'wcamp'
	
  def index
		@work_no = ''
		list
  end

	def list
		@work_receives = WorkReceive.find(:all)
		@receives = Receive.find(:all, :conditions => {:work_no => @work_no})
	end

end
