class FrontController < ApplicationController
  
  def index
    if logged_in?
      process_for_authenticated_user
      render :action => 'user_view', :layout => 'authenticated_layout'
    else
      process_for_anonymous_user
      render :layout => 'app_layout'
    end
  end
  

protected 

  def process_for_authenticated_user
    @tasks = Task.find_active_tasks_for_user current_user.id
  end
  
  def process_for_anonymous_user
    @task_ids = get_temp_task_ids_from_cookies
    @tasks = @task_ids.empty? ? [] : Task.find_temp_tasks( @task_ids )
  end

end