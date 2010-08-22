class CtlController < CaseinController #ApplicationController
	layout "wcamp"
	
  def index
		@work_orders = WorkOrder.find(:all)
		list		
  end

	def list
		@active_orders = WorkOrder.active
	end

	def search
		if [nil,''].include?(params[:search])
			@work_orders = WorkOrder.find(:all)
		else
			@work_orders = WorkOrder.find(:all, :conditions => {:work_no => params[:search]})
		end
		render_page
	end
	
	def show
		work_order = WorkOrder.find(params[:id].to_i)
		render :update do |page|
			page.replace_html "work_order_#{params[:id]}", 
				render(:partial => "order_list", :locals => {:work_order => work_order})
		end
	end

	def close
		work_order = WorkOrder.find(params[:id].to_i)
		render :update do |page|
			page.replace_html "work_order_#{work_order.id}", ""
		end
	end
	
	def render_page
		list
		render :update do |page|
			page.visual_effect :highlight, 'order_list', :duration => 2
			page.replace_html 'work_order_list', render(:partial => 'work_order_list')
		end
	end
end
