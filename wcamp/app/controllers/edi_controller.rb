class EdiController < CaseinController #ApplicationController
	layout 'wcamp'
  def index
		list
  end

	def list
		@edi_files = EdiFile.find(:all)		
	end

	def edi_start
		eval("EdiFile.#{params[:tag]}")
		render_page
	end

	def render_page
		render :update do |page|
			page.visual_effect :highlight, 'edi_class_list', :duration => 2
			page.replace_html 'edi_class_list', render(:partial => 'edi_class_list')	
		end	
	end
end
