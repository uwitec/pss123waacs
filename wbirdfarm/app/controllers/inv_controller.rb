class InvController < CaseinController
	layout "bf"
  def index
		list
  end

	def list
		@inventries = Inventory.all
		@ware_houses = WareHouse.all
	end
end
