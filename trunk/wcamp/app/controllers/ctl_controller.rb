class CtlController < CaseinController #ApplicationController
	layout "wcamp"
	
  def index
		list		
  end

	def list
		@work_orders = WorkOrder.find(:all)
	end
end
