class InvController < CaseinController
	layout "bf"

  def index
		@keyword.reset
		list
  end

	def search
		list
		logger.debug @keyword.ware_house
		render_page
	end

	def list
		@keyword.set (params[:keyword] || params)
		@ware_houses = [@session_user.ware_house].compact
		@ware_houses = WareHouse.all if @session_user.is_admin?
		unless [nil,''].include?(@keyword.ware_house)
			conditions = {:ware_house_id => @keyword.ware_house.to_i}
		else	
			conditions = {:ware_house_id => @ware_houses.map{|w| w.id}}
		end

		@inventories = Inventory.goods_code_or_goods_name_like(@keyword.search).paginate(
			:conditions => conditions,
			:order => 'ware_house_id, goods_code, location',
			:page => params[:page],
			:per_page => 5
		)
	end

	def render_page
		render :update do |page|
			page.replace_html 'inv_list', render(:partial => 'inv_list')
			page.replace_html 'search_inv', render(:partial => 'shared/search_inv')
		end
	end
end
