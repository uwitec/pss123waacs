class PickingPlanController < CaseinController
	layout "bf"

  def index
		@picking_style = ''
		@customer_code = ''
		list
  end

	def list
		@ware_houses = WareHouse.all
	end

	def reset_allocate
		PickingPlan.allocated_clear
		render_page	
	end

	def allocate_single
		PickingPlan.new.allocate_single
		render_page	
	end

	def allocate_total
		PickingPlan.new.allocate_total
		render_page	
	end

	def change_picking_style
		shipping_addresses = ShippingAddress.all(:conditions => {:customer_code => params[:customer_code]})
		@customer_code = params[:customer_code]
		@picking_style = shipping_addresses.map{|s| s.picking_style }.uniq.compact[0]
		unless [nil,''].include?(params[:picking_style])
			shipping_addresses.each do |sa|
				sa.picking_style = params[:picking_style]
				sa.save
			end
		end
		@picking_style = shipping_addresses.map{|s| s.picking_style}.uniq.compact[0]
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
