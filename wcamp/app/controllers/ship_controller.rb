class ShipController < CaseinController #ApplicationController
	layout 'wcamp'
	
  def index
		@keyword.reset
		@keyword.work_no = 'none'
		list
  end

	def list
		@work_orders = WorkOrder.find(:all, :order => 'max_status')
		@orders = ShipOrder.find(:all, :conditions => @keyword.search_shipping_conditions)
	end

	def search
		@keyword.set (params[:keyword] || params)
		render_page
	end

	def confirm
		params[:orders].each do |r|
			next if [nil,''].include?(r[:id])
			order = ShipOrder.find(r[:id].to_i)
			order.result_qty = r[:result_qty].to_i
			order.end_at = DateTime.now
			order.status = '50'
			order.save
		end
		list
		render_page
	end

	def set_all_qty
		orders = ShipOrder.find(:all, :conditions => @keyword.search_shipping_conditions)
		orders.each do |order|
			order.result_qty = order.order_qty
			order.start_at = DateTime.now
			order.status = '40'
			order.save
		end	
		list
		render_page
	end

	def render_page
		list
		render :update do |page|
			page.visual_effect :highlight, 'order_list', :duration => 2
			page.visual_effect :highlight, 'work_order_list', :duration => 2
			page.replace_html 'order_list', render(:partial => 'order_list')
			page.replace_html 'work_order_list', render(:partial => 'work_order_list')
			page.replace_html 'search', render(:partial => 'search')
		end
	end
end
