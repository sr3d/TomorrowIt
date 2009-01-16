class TasksController < ApplicationController
  def index
  end

  def new
  end

  def create
    @task = Task.new( :name => params[:task][:name].strip )
    @task.save!
    
    append_task_to_anonymous_cookies @task
    
  end

  def destroy
  end

  def show
  end

  def update
  end
  
  protected 
  
  def append_task_to_anonymous_cookies( task )
    task_ids = cookies[:temp_tasks].nil? ? [] : cookies[:temp_tasks].split(',')
    task_ids.push task.id

    cookies[ :temp_tasks ] = { :value => task_ids.join( ',' ), :expires => 999.days.from_now }
  end
  

end
