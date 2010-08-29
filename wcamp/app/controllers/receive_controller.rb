class ReceiveController < CaseinController # ApplicationController
	layout 'wcamp'
	
  def index
		@keyword.reset
		list
  end

	def list
		@work_receives = WorkReceive.find(:all, :order => 'max_status')
		@receives = Receive.paginate(
			:page => params[:page],
			:conditions => @keyword.search_receive_conditions,
			:per_page => 4)
	end

	def search
		@keyword.set (params[:keyword] || params)
		list
		render_page
	end

	def set_all_qty
		@keyword.set (params[:keyword] || params)
		receives = Receive.find(:all, :conditions => @keyword.search_receive_conditions)
		receives.each{|r| r.result_qty = r.announced_qty; r.save }
		list
		render_page
	end

	def confirm
		params[:receives].each do |r|
			next if [nil,''].include?(r[:id])
			receive = Receive.find(r[:id].to_i)
			receive.location = r[:location]
			receive.result_qty = r[:result_qty].to_i
			receive.status = '50'
			receive.save
		end
		list
		render_page
	end

	def new
		@receive = Receive.new
		render :update do |page|
			page.replace_html 'new_receive', render(:partial => 'new_receive')
		end
	end

	def create
		@receive = Receive.new(params[:receive])
		@receive.work_no = Date.today.strftime('%Y%m%d') + '999'
		@receive.status = '50'
		logger.debug @receive.error.full_messages unless @receive.save
		list
		render_page
	end

	def render_page
		render :update do |page|
			page.visual_effect :highlight, 'receive_list', :duration => 2
			page.visual_effect :highlight, 'work_receive_list', :duration => 2
			page.replace_html 'receive_list', render(:partial => 'receive_list')
			page.replace_html 'work_receive_list', render(:partial => 'work_receive_list')
			page.replace_html 'search', render(:partial => 'search')
		end
	end
end
