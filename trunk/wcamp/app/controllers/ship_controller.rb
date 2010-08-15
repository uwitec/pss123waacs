class ShipController < CaseinController #ApplicationController
	layout 'ship'
	
  def index
		@work_no = ''	
		list
  end

	def list
		@orders = ShipOrder.find(:all, :conditions => {:work_no => @work_no})
	end

	def search
		@work_no = params[:work_no]
		render_page
	end

	def render_page
		list
		render :update do |page|
			page.visual_effect :highlight, 'order_list', :duration => 2
			page.replace_html 'order_list', render(:partial => 'order_list')
		end
	end
end
