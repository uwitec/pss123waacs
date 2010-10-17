class InvController < CaseinController
	layout "bf"

  def index
		list
  end

	def list
		@search = params[:search]
		@inventories = Inventory.goods_code_or_goods_name_like(@search).paginate(
			:order => 'ware_house_id, goods_code, location',
			:page => params[:page],
			:per_page => 5
		)
		@ware_houses = WareHouse.all
	end

	def search
		list
		render_page
	end
	
	def render_page
		render :update do |page|
			page.replace_html 'inv_list', render(:partial => 'inv_list')
			page.replace_html 'search_inv', render(:partial => 'shared/search_inv')
		end
	end
end
