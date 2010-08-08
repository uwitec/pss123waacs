class CaseinController < ApplicationController

  require 'casein_helper'
  include CaseinHelper

	require 'casein_config_helper'
	include CaseinConfigHelper

  layout 'casein_main'
  before_filter :login_from_cookie
  before_filter :authorise

  ActionView::Base.field_error_proc = proc { |input, instance| input } 

  def index		
		redirect_to casein_config_dashboard_url
  end

	def blank
		@casein_page_title = "Welcome"
	end

private
  
  def authorise    
    @session_user = casein_get_session_user
		unless @session_user
		  session[:original_uri] = request.request_uri
		  redirect_to(:controller => :casein_auth, :action => :login)
		end
	end
	
	def login_from_cookie
    if @session_user.nil? and cookies[:remember_me_id] and cookies[:remember_me_code]
      user = CaseinUser.find(cookies[:remember_me_id])
      if create_user_code(user) == cookies[:remember_me_code]  
        session[:casein_user_id] = user.id     
      end
    end
  end
  
  def clear_session_and_cookies
    session[:casein_user_id] = nil
		 
		if cookies[:remember_me_id] then cookies.delete :remember_me_id end
    if cookies[:remember_me_code] then cookies.delete :remember_me_code end
  end
	
	def create_user_code user
    Digest::SHA1.hexdigest(user.email)[4,18]
  end
  
  def needs_admin
    unless @session_user.is_admin?
      redirect_to :controller => :casein, :action => :index
    end
  end
  
  def needs_admin_or_current_user
    unless @session_user.is_admin? || params[:id].to_i == @session_user.id
      redirect_to :controller => :casein, :action => :index
    end
  end

end
