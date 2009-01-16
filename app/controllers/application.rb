# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7f64e1cf91613e7a889d2635b08bb2d0'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  
protected
  def log_user_in( user )
    self.current_user = user
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    flash[:notice] = "Logged in successfully"
  end
  
end
