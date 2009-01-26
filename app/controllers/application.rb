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
  
  before_filter :adjust_format_for_iphone
  
  
protected

  # iPhone integration
  def adjust_format_for_iphone
    request.format = :iphone if iphone_request?
    flash[:notice] = "iphone"
  end

  # Return true for requests to iphone.trawlr.com
  def iphone_request?
    return (request.subdomains.first == "iphone" || params[:format] == "iphone")
  end



  def log_user_in( user )
    self.current_user = user
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    associate_temp_tasks_to_user
    
    #flash[:notice] = "Logged in successfully"
  end
  
  def cookies_task_ids
    @cookies_task_ids ||= ( cookies[:temp_tasks ].nil? ) ? [] : cookies[:temp_tasks].split(',').collect{ |task_id| task_id.to_i }
  end

  def cookies_task_ids=( new_value)
    cookies[:temp_tasks ] = new_value
    @cookies_task_ids = nil
  end

  
  def associate_temp_tasks_to_user
    return if !logged_in? or cookies_task_ids.empty?
    logger.debug 'associating tasks'
    Task.associate_temp_tasks_to_user( cookies_task_ids, current_user )
    # clear the 
    logger.debug cookies_task_ids.inspect
    clear_cookies_task_ids
  end
  
  
  def clear_cookies_task_ids
    cookies.delete :temp_tasks
  end

end
