class ChainTasksController < ApplicationController
  before_filter :login_required, :except => [  ]
  def create
  end
  
  def get_calendar
    
    # @calendar_html = render_to_string :partial => 'shared/calendar', :locals => { :items => item }
    @chain_task = ChainTask.find_by_id_and_user_id( params[:id], current_user.id )
    render :nothing and return unless @chain_task
    
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
  end

  def toggle_status
  end

  def toggle_date
    @chain_task = ChainTask.find_by_id_and_user_id( params[:id], current_user.id )
    render :nothing unless @chain_task
    @date = Time.parse( params[:date] ).to_date
    @chain_task.toggle_date @date
    render :text => :ok and return
  end

end
