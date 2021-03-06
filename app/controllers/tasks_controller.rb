class TasksController < ApplicationController
  before_filter :login_required, :only => [ :tasks_for_date ]
  
  def index
  end

  def new
  end
 
  def create
    return if params[:task][:name].blank?
    
    @task = Task.new( :name => params[:task][:name].strip )
    @task.description = params[:task][:description].strip unless params[:task][:description].nil? 
    @task.user_id = current_user.id if logged_in?
    
    @task.save!
    
    unless logged_in? 
      append_task_to_anonymous_cookies @task
    end  

    respond_to do |format|
      format.html
      
      
      format.js do 
        render :update do |page|
          page.show "tasks_wrapper"
          page.insert_html :top, 'tomorrow_tasks_wrapper', :partial => 'tasks/tomorrow_item', :locals => { :task => @task, :visible => 'display:none;' }
          page.visual_effect :blind_down, "item_wrapper_#{@task.id}", :duration => 0.3
          page.visual_effect :highlight, "item_wrapper_#{@task.id}", :duration => 0.6
          
          page << 'checkForEmptyTasks();'
        end
      end
      
      format.iphone do 
        redirect_to :controller => "front", :action => "index"
        
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
    return unless @task
    
    # only allow anonymous 
    if ( @task.user_id.nil? and cookies_task_ids.include? @task.id ) or (logged_in? and @task.user_id == current_user.id )
      @task.done!
      
      respond_to do |format|
        format.html { redirect_to "/" }
        
        format.js do
          render :update do |page|
            page.visual_effect :blind_up, "item_wrapper_#{@task.id}", :duration => 0.3, 
              :afterFinish => "function() { $('item_wrapper_#{@task.id}').remove(); checkForEmptyTasks();}"
          end #render
        end #js

      end
    else
      render :text => :failed
    end # if task updatable
    
    
  end
  
  def tomorrow_it
    @task = Task.find( params[:id] )
    @task.due_date= Time.now.to_date + 1
    
    success = @task.save if ( logged_in? and @task.user_id == current_user.id ) or cookies_task_ids.include?( params[:id].to_i )
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

            page << 'checkForEmptyTasks();'
          end #render
        end # js
        
      end # respond_to
    end
    
  end
  
  def today_it
    @task = Task.find( params[:id] )
    @task.due_date = @today = Time.now.to_date
    
    
    success = @task.save if ( logged_in? and @task.user_id == current_user.id ) or cookies_task_ids.include?( params[:id].to_i )
    
    if success
      respond_to do |format|
        format.html { redirect_to :controller => "front", :action => "index"}
        format.js do 
          
          @task_html = render_to_string( :partial => 'tasks/today_item', :locals => { :task => @task, :visible => 'display:none;' } )
          
          render :update do |page|
            wrapper_id = "item_wrapper_#{@task.id}"
            page.remove wrapper_id

            # If not the current date then shouldn't move it to the list
            page << %!
              (function(){
                if( \!window.displayedDate || window.displayedDate == '#{@today.to_s(:db)}' )
                {
                  $('today_tasks_wrapper').insert( { top: '#{escape_javascript( @task_html ) }' } );
                  Effect.BlindDown( '#{wrapper_id}', { duration: 0.3 } );
                  new Effect.Highlight( '#{wrapper_id}', { duration: 0.6 } );
                }
              })();
            !
            # insert the item to the "tommorrow list"
            #page.insert_html :top, 'today_tasks_wrapper', :partial => 'tasks/today_item', 
            #  :locals => { :task => @task, :visible => 'display:none;' }
            #page.visual_effect :blind_down, "item_wrapper_#{@task.id}", :duration => 0.3
            #page.visual_effect :highlight, "item_wrapper_#{@task.id}", :duration => 0.6
            
            page << 'checkForEmptyTasks();'
          end #render
        end # js
        
      end # respond_to
  
    else
      render :text => 'failed'
    end
  
    
  end
  
  def tasks_for_date
    @date = Time.parse( params[:date] ).to_date
    @tasks = Task.find_tasks_for_date( current_user, @date )
    @tasks_html = render_to_string( :partial => 'shared/left_tasks_list', :locals => { :tasks => @tasks } )
    
    @title_text = render_to_string( :partial => 'shared/today_and_previous_day_title',
                    :locals => { :date => @date } )
    respond_to do |format|
      #format.html
      
      format.js do

        
      end
    end # respond
    
  end
  
protected 
  
  def append_task_to_anonymous_cookies( task )
    task_ids = cookies_task_ids
    task_ids.push task.id

    cookies[ :temp_tasks ] = { :value => task_ids.join( ',' ), :expires => 999.days.from_now }
  end
  
end
