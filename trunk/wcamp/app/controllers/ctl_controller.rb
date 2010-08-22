class CtlController < CaseinController #ApplicationController
	layout "wcamp"
	
  def index
		list		
  end

	def list
		@work_orders = WorkOrder.find(:all)
		@active_orders = WorkOrder.active
	end

	def show
		work_order = WorkOrder.find(params[:id].to_i)
		render :update do |page|
			page.replace_html "work_order_#{params[:id]}", 
				render(:partial => "/shared/order_list", :locals => {:work_order => work_order})
		end
	end

	def close
		work_order = WorkOrder.find(params[:id].to_i)
		render :update do |page|
			page.replace_html "work_order_#{work_order.id}", ""
		end
	end
end
