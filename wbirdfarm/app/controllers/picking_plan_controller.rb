class PickingPlanController < CaseinController
	layout "bf"

  def index
		list
  end

	def list
		@ware_houses = WareHouse.all
	end

	def reset_allocate
		PickingPlan.allocated_clear
		render_page	
	end

	def render_page
		list
		render :update do |page|
			page.visual_effect :highlight , "inv_control"
			page.replace_html 'inv_control', render(:partial => 'inv_control')
		end
	end

end
