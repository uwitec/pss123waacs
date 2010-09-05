class CtlController < CaseinController #ApplicationController
	layout "wcamp"
	
  def index
		unless @session_user.is_admin?
			redirect_to :controller => 'ship'
		end
		@work_orders = WorkOrder.find(:all)
		list		
  end

	def list
		@active_orders = WorkOrder.find(:all, :order => 'max_status')
		@active_receives = WorkReceive.find(:all, :order => 'max_status')
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
			page.replace_html "work_order_#{work_order.id}", '<td colspan="8" style="padding:0px;margin:0px;border:0px;"></td>'
		end
	end
	
	def render_page
		list
		render :update do |page|
			page.replace_html 'work_order_list', render(:partial => 'work_order_list')
			page.visual_effect :highlight, 'active_order_list', :duration => 2
			page.visual_effect :highlight, 'active_receive_list', :duration => 2
			page.replace_html 'active_order_list', render(:partial => 'active_order_list')
			page.replace_html 'active_receive_list', render(:partial => 'active_receive_list')
		end
	end
end
