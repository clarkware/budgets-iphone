class ApplicationController < ActionController::Base
  include Authentication
  
  helper :all
  
  protect_from_forgery 
  
  filter_parameter_logging :password
  before_filter :login_required
  
end
