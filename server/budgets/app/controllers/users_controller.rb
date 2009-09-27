class UsersController < ApplicationController
  
  skip_before_filter :login_required
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thanks for signing up! You're now logged in."
      redirect_to root_url
    else
      render :action => :new
    end
  end
end
