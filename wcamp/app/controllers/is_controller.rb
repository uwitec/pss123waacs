class IsController < ApplicationController
  def index
		@work_orders = WorkOrder.find(:all)
		@title = "WAACS for iPhone"
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
end
