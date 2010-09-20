class InvController < CaseinController
	layout "bf"
  def index
  end

	def list
		@inventries = Inventry.find(:all)
	end
end
