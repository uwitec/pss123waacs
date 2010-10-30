# Scaffolding generated by Casein v.2.0.6

class CaseinNumberMastersController < CaseinController
 
  ## optional filters for defining usage according to casein_users access_levels
  # before_filter :needs_admin, :except => [:action1, :action2]
  # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
 
  def index
		if request.get?
			@casein_page_title = 'Number masters'
			@number_masters = NumberMaster.paginate :all, :page => params[:page]
		end
  end
 
  def new
		if request.get?
			@casein_page_title = 'Add a new number master'
    	@number_master = NumberMaster.new
		end
  end

  def create
    if request.post?
      @number_master = NumberMaster.new params[:number_master]
      
      unless @number_master.save
        flash[:warning] = 'There were problems when trying to create a new number master'
        render :action => :new
        return
      end
      
      flash[:notice] = 'Number master created'
    end
    redirect_to casein_number_masters_path
  end
  
  def show
		if request.get?
   	 @number_master = NumberMaster.find params[:id]
    
	    if @number_master.nil?
	      redirect_to casein_number_masters_path
	    end

			@casein_page_title = 'View number master'
		end
  end
 
  def update
    if request.put?
      @number_master = NumberMaster.find params[:id]

      if @number_master
        @casein_page_title = 'Update number master'

        unless @number_master.update_attributes params[:number_master]
          flash[:warning] = 'There were problems when trying to update this number master'
          render :action => :show
          return
        end
        flash[:notice] = 'Number master has been updated'
      end
    end

    redirect_to casein_number_masters_path
  end
 
  def destroy
    if request.delete?
      @number_master = NumberMaster.find_by_id params[:id]

      if @number_master
        flash[:notice] = 'Number master has been deleted'
        @number_master.destroy
      end
    end

    redirect_to :back
  end
  
end