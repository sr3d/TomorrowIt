class FrontController < ApplicationController
  #layout 'unauthenticated_layout'
  
  def index
    if logged_in?
      logger.debug "logged in user: #{current_user}"
      process_for_authenticated_user
      render :action => 'user_view', :layout => 'authenticated_layout'
    else
      process_for_anonymous_user

      
      
      respond_to do |format|
        
        format.iphone { 
          render :layout => 'app_layout.iphone.erb'
          logger.debug 'test'
       }
       
        format.html { render :layout => 'app_layout' }

      end
    end
  end
  

 
  def about;end
  def help;end


protected 

  def process_for_authenticated_user
    @tasks = Task.find_active_tasks_for_user current_user.id
    @chain_tasks = current_user.is_chain_enabled ? ChainTask.find_by_user(current_user) : []
    process_tasks
  end
  
  def process_for_anonymous_user
    @task_ids = cookies_task_ids
    @tasks = @task_ids.empty? ? [] : Task.find_temp_tasks( @task_ids )
    process_tasks
  end

  def process_tasks
    @today, @tomorrow = Time.now.to_date, (Time.now.to_date + 1.day)
    @today_tasks = @tasks.collect{ |task| task if task.due_date.to_date == @today }.compact
    @tomorrow_tasks = @tasks.collect{ |task| task if task.due_date.to_date == @tomorrow }.compact
  end

end
