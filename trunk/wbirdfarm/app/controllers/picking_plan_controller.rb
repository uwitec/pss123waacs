class PickingPlanController < CaseinController
	layout "bf"

  def index
		list
  end

	def list
		@ware_houses = WareHouse.all
	end

end
