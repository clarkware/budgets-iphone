# This module is included in your application controller which makes
# several methods available to all controllers and views. Here's a
# common example you might add to your application layout file.
# 
#   <% if logged_in? %>
#     Welcome <%= current_user.username %>! Not you?
#     <%= link_to "Log out", logout_path %>
#   <% else %>
#     <%= link_to "Sign up", signup_path %> or
#     <%= link_to "log in", login_path %>.
#   <% end %>
# 
# You can also restrict unregistered users from accessing a controller using
# a before filter. For example.
# 
#   before_filter :login_required, :except => [:index, :show]
#
module Authentication
  
  def self.included(controller)
    controller.send :helper_method, :current_user, 
                    :logged_in?, :admin_logged_in? 
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    current_user
  end
  
  def admin?
    logged_in? && current_user.is_admin? 
  end
  
  def admin_required
    admin? || login_required
  end
  
  def login_required
    return if logged_in?
      
    respond_to do |format| 
      format.html do
        save_location
        redirect_to login_url
      end
      format.any(:json, :xml) do
        if user = authenticate_from_basic_auth
          session[:user_id] = user.id
        else
          request_http_basic_authentication 'Web Password'
        end
      end
    end 
  end
  
  def authenticate_from_basic_auth
    authenticate_with_http_basic do |login, password|
      User.authenticate(login, password)
    end
  end
  
  # Save the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def save_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent save_location call or
  # to the passed default.  Set an appropriately modified
  #   after_filter :store_location, :only => [:index, :new, :show, :edit]
  # for any controller you want to be bounce-backable.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end