class SessionsController < ApplicationController
  
  skip_before_filter :login_required, :only => [:new, :create]
  
  def new
  end
  
  def create
    user = User.authenticate(params[:session][:login], 
                             params[:session][:password])
  
    respond_to do |format|
      if user
        format.html do 
          reset_session
          session[:user_id] = user.id
          redirect_back_or_default root_url 
        end
        format.any(:xml, :json) { head :ok }
      else
        format.html do 
          flash.now[:error] = "Invalid login or password."
          render :action => :new 
        end
        format.any(:xml, :json) { request_http_basic_authentication 'Web Password' }
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've been logged out."
    redirect_to root_url
  end
  
end
