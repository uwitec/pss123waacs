class ReceiveController < CaseinController # ApplicationController
	layout 'wcamp'
	
  def index
		@keyword.reset
		list
  end

	def list
		@work_receives = WorkReceive.find(:all)
		@receives = Receive.find(:all, :conditions => @keyword.search_receive_conditions)
	end

	def search
		@keyword.set (params[:keyword] || params)
		list
		render_page
	end

	def set_all_qty
		@keyword.set (params[:keyword] || params)
		@receives = Receive.find(:all, :conditions => @keyword.search_receive_conditions)
		@receives.each{|r| r.result_qty = r.announced_qty }
		render_page
	end

	def confirm
		params[:receives].each do |r|
			next if [nil,''].include?(r[:id])
			receive = Receive.find(r[:id].to_i)
			receive.location = r[:location]
			receive.result_qty = r[:result_qty].to_i
			receive.save
		end
		list
		render_page
	end

	def render_page
		render :update do |page|
			page.visual_effect :highlight, 'receive_list', :duration => 2
			page.replace_html 'receive_list', render(:partial => 'receive_list')
			page.replace_html 'search', render(:partial => 'search')
		end
	end
end
