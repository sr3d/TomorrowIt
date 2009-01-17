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

  def done
    @task = Task.find( params[:id] )

    # only allow anonymous 
    if @task.user_id.nil?
      @task.done!
      
      respond_to do |format|
        format.html
        
        format.js do
          render :update do |page|
            page.visual_effect :blind_up, "item_wrapper_#{@task.id}", :duration => 0.3, 
              :afterFinish => "function() { $('item_wrapper_#{@task.id}').remove(); }"
          end #render
        end #js

      end

    end
  end
  
  def tomorrow_it
    @task = Task.find( params[:id] )
    @task.due_date= Time.now.to_date + 1
    
    success = @task.save if ( logged_in? and @task.user_id == current_user.id ) or cookies_task_ids.include?( params[:id] )
    if success
      respond_to do |format|
        format.html { redirect_to :controller => "front", :action => "index"}
        format.js do 
          render :update do |page|
            page.remove "item_wrapper_#{@task.id}"

            # insert the item to the "tommorrow list"
            page.insert_html :top, 'tomorrow_tasks_wrapper', :partial => 'tasks/tomorrow_item', 
              :locals => { :task => @task, :visible => 'display:none;' }
            page.visual_effect :blind_down, "item_wrapper_#{@task.id}", :duration => 0.3
            page.visual_effect :highlight, "item_wrapper_#{@task.id}", :duration => 0.6

          end #render
        end # js
        
      end # respond_to
    end
    
  end
  
  def today_it
    @task = Task.find( params[:id] )
    @task.due_date= Time.now.to_date
    
    success = @task.save if ( logged_in? and @task.user_id == current_user.id ) or cookies_task_ids.include?( params[:id] )
    if success
      respond_to do |format|
        format.html { redirect_to :controller => "front", :action => "index"}
        format.js do 
          render :update do |page|
            page.remove "item_wrapper_#{@task.id}"

            # insert the item to the "tommorrow list"
            page.insert_html :top, 'today_tasks_wrapper', :partial => 'tasks/today_item', 
              :locals => { :task => @task, :visible => 'display:none;' }
            page.visual_effect :blind_down, "item_wrapper_#{@task.id}", :duration => 0.3
            page.visual_effect :highlight, "item_wrapper_#{@task.id}", :duration => 0.6
          end #render
        end # js
        
      end # respond_to
    end
    
  end
  
  
protected 
  
  def append_task_to_anonymous_cookies( task )
    task_ids = cookies_task_ids
    task_ids.push task.id

    cookies[ :temp_tasks ] = { :value => task_ids.join( ',' ), :expires => 999.days.from_now }
  end
  
  def cookies_task_ids
    cookies[:temp_tasks].nil? ? [] : cookies[:temp_tasks].split(',')
  end

end
