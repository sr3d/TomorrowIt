class FrontController < ApplicationController
  
  def index
    if logged_in?
      process_for_authenticated_user
      render :action => 'user_view', :layout => 'authenticated_layout'
    else
      render :layout => 'app_layout'
    end
  end
  

protected 

  def process_for_authenticated_user
    @tasks = Task.find_active_tasks_for_user current_user.id
  end

end
