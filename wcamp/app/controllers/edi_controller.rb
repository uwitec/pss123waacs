class EdiController < CaseinController #ApplicationController
	layout 'wcamp'
  def index
		list
  end

	def list
		@edi_files = EdiFile.find(:all)		
	end
end
