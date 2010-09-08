class IsController < ApplicationController

  def index
		list
		@title = "WAACS for iPhone"
  end

	def list
		@work_orders = WorkOrder.find(:all, :conditions => "max_status in(10,20,30) or max_status is null")
	end

	def show_today
		list
		render :update do |page|
			page.replace_html 'work', ''
			page.replace_html 'work_order_list', render(:partial => 'work_order_list')
		end
	end

	def clock
		@title = "テスト"
	end

	def picking
		orders = WorkOrder.find(params[:id].to_i).ship_orders
		render :update do |page|
			page.replace_html 'work', 
				render(:partial => 'order_list', :locals => {:orders => orders})
		end
	end

	def picked
		order = ShipOrder.find(params[:id])
		order.result_qty = order.order_qty
		order.status = '30'
		order.end_at = DateTime.now
		order.save
		orders = WorkOrder.find_by_work_no(order.work_no).ship_orders
		render :update do |page|
			page.replace_html 'work', 
				render(:partial => 'order_list', :locals => {:orders => orders})
		end
	end
end
