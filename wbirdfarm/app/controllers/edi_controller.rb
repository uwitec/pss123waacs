class EdiController < CaseinController
	layout "bf"
  def index
		list
  end

	def list
		@ware_houses = WareHouse.all
		@edi_files = EdiFile.find(:all, :order => 'edi_at desc', :limit => 20)
	end

	def refresh
		render_page
	end

	def edi_start
		eval("EdiFile.#{params[:tag]}")
		render_page
	end

	def download
		send_file params[:file]
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
