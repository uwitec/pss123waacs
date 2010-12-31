class EdiController < CaseinController #ApplicationController
	layout 'wcamp'
	
  def index
		unless @session_user.is_admin?
			redirect_to :controller => 'ship'
		end
		list
  end

	def list
		@edi_files = EdiFile.find(:all, :order => 'edi_at desc', :limit => 20)
	end

	def edi_start
		eval("EdiFile.#{params[:tag]}")
		render_page
	end

	def upload_start
		Edi.new.upload_file "shipped"	
		render_page
	end

	def download_start
		Edi.new.download_file "shipping"	
		render_page
	end

	def download
		send_file params[:file]
	end

	def refresh
		render_page
	end

	def render_page
		list
		render :update do |page|
			page.visual_effect :highlight, 'edi_class_list', :duration => 2
			page.replace_html 'edi_class_list', render(:partial => 'edi_class_list')	
			page.visual_effect :highlight, 'edi_file_list', :duration => 2
			page.replace_html 'edi_file_list', render(:partial => 'edi_file_list')	
		end	
	end
end
