class ChainTasksController < ApplicationController
  before_filter :login_required, :except => [  ]
  before_filter :load_chain_task, :except => [ :create ]
  
  def create
    
    @chain_task = ChainTask.new( :name => params[:chain_task][:name], :user_id => current_user.id, :is_active => true )
    success = @chain_task.save
    render :nothing => true and return unless success
    
    respond_to do |format|
      format.js do 
        
        render :update do |page|
          
          page.insert_html :top, 'chains_wrapper', :partial => 'chain_tasks/item', :locals => { :item => @chain_task, :visible => 'display:none;' }
          page.visual_effect :blind_down, "chain_wrapper_#{@chain_task.id}", :duration => 0.3
          page.visual_effect :highlight, "chain_wrapper_#{@chain_task.id}", :duration => 0.6          
        end
        
        
      end
    end
    
    
  end
  
  def get_calendar
    
    # @calendar_html = render_to_string :partial => 'shared/calendar', :locals => { :items => item }
    #@chain_task = ChainTask.find_by_id_and_user_id( params[:id], current_user.id )
    render :nothing => true and return unless @chain_task
    
    @date = params[:date].nil? ? Time.now.to_date : Time.parse( params[:date] )
    @items = @chain_task.load_history_for_month( @date )
    
    respond_to do |format|
      format.js do 
        
        render :update do |page|
          
          page.replace_html 'calendar_wrapper', :partial => 'shared/calendar', :locals => { :items => @items }
          page << "window.currentChainTaskId = '#{@chain_task.id}'; "
          
        end
        
        
      end
    end
    
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
    render :nothing => true unless @chain_task
    @chain_task.delete!
    respond_to do |format|
      format.html {}
      format.js do 
        render :update do |page|
          page.visual_effect :blind_up, "chain_wrapper_#{@chain_task.id}", :duration => 0.3, 
              :afterFinish => "function() { $('chain_wrapper_#{@chain_task.id}').remove(); }"
        end
      end
    end
  end

  # toggle status of a chain_task to be active/inactive
  def toggle_status
    @chain_task.toggle_status!
    render :text => :ok and return
  end

  def toggle_date
    render :nothing => true unless @chain_task
    @date = Time.parse( params[:date] ).to_date
    @chain_task.toggle_date @date
    render :text => :ok and return
  end
  
  def color
    @chain_task.update_attribute :color, params[:color]
    render :text => :ok
  end
  
  def toggle_chain_task_feature
    current_user.toggle_chain_task_feature!
    
    respond_to do |format|
      format.html {}
      format.js do 
        render :update do |page|
          if current_user.is_chain_enabled
            @chain_tasks = ChainTask.find_all_chain_tasks_for_user current_user
            page.replace_html 'chains_wrapper', :partial => 'users/chain_tasks'
            page.visual_effect :blind_down, "chains_wrapper", :duration => 0.3
          else
            page.visual_effect :blind_up, "chains_wrapper", :duration => 0.3,
              :afterFinish => 'function() { $("chains_wrapper").innerHTML = ""; }'
          end
          
        end
      end
    end    
  end
  
  private
  
  def load_chain_task
    @chain_task = ChainTask.find_by_id_and_user_id( params[:id], current_user.id )
  end

end
