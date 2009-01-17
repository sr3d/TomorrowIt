class TasksController < ApplicationController
  def index
  end

  def new
  end

  def create
    return if params[:task][:name].blank?
    
    @task = Task.new( :name => params[:task][:name].strip )
    @task.save!
    append_task_to_anonymous_cookies @task
    
    respond_to do |format|
      format.html
      
      
      format.js do 
        render :update do |page|
          page << ''
          page.insert_html :top, 'tomorrow_tasks_wrapper', :partial => 'tasks/tomorrow_item', :locals => { :task => @task, :visible => 'display:none;' }
          page.visual_effect :blind_down, "item_wrapper_#{@task.id}", :duration => 0.3
          page.visual_effect :highlight, "item_wrapper_#{@task.id}", :duration => 0.6
        end
      end
      
    end
    
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
