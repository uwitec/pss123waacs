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
		@keyword.set params[:keyword]	
		render_page
	end
	
	def render_page
		list
		render :update do |page|
			page.visual_effect :highlight, 'receive_list', :duration => 2
			page.replace_html 'receive_list', render(:partial => 'receive_list')
		end
	end
end
