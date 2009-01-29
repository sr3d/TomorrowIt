class UsersController < ApplicationController
  layout 'authenticated_layout'  
  before_filter :login_required, :except => [ :forgot_password, :new, :index, :create  ]
  
  def index
    respond_to do |format|
      redirect_to :controller => 'front', :action => 'index' and return
    end
  end
  
  def show
    redirect_to :controller => 'front', :action => 'index' and return
  end

  # render new.rhtml
  def new
    @user = User.new
  end
  
  def edit
    @user = current_user
    
    @chain_tasks = ChainTask.find_all_chain_tasks_for_user current_user
    
  end
  
  def update
    @user = current_user
    @user.email = params[:user][:email]
    if !params[:user][:password].nil? 
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
    end
    
    success = @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Your account has been updated"
    else
      # flash[:error]  = "Something wen"
      render :action => 'edit'
    end
  end
  
  def new_ical_url
    current_user.new_token!

    respond_to do |format|
      format.js do 
        render :update do |page|
          page.replace_html 'ical_url', link_to( user_unique_ical_url, user_unique_ical_url )
           page.visual_effect :highlight, "ical_url", :duration => 0.6
        end
      end

      # HTML 
      format.html do
        redirect_to :controller => "front", :action => "index" and return
      end
    end #respond
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save && @user.errors.empty?
    
    if success 
      log_user_in @user
    end
    
    respond_to do |format|
      format.js do 
        if success 
          # flash[:notice] = "Thanks for signing up"
          render :update do |page|
            page << "location.reload(true);"
          end
        else
          render :update do |page|
            msg = ''
            @user.errors.each { |attribute, error | msg += "#{attribute}: #{error} \\n"}
            page << "alert(\"#{msg}\");"
          end
        end
      end

      # HTML 
      format.html do
        if success && @user.errors.empty?
          redirect_back_or_default('/')
          flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
        else
          flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
          render :action => 'new'
        end
      end
      
      
      format.iphone do
        if success && @user.errors.empty?
          redirect_to :controller => "front", :action => "index"
        end
      end
      
    end #respond
  end

  
  def forgot_password
    @email = params[:user][:email]
    success = @email && !!@email.match( Authentication::RE_EMAIL_OK )
    
    @user = User.find_by_email( params[:user][:email] ) if success
    success = @user && @user.reset_password! 

    respond_to do |format|
      format.html do 
        if success
          flash[:notice] = "please check your email for the new password"
        else
          flash[:notice] = "Could not find your user";
        end
        redirect_to :controller => "front", :action => "index"
      end
      
      format.js do 
        render :update do |page|
          if success
            page.alert( 'please check your email for the new password' );
            page.hide "forgot_password_form_wrapper"
            page.hide "forgot_password_wrapper"
          else
            page.alert( 'Could not find your user' )
          end
        end #render
      end # js
      
    end #respond_to
  end
  

end
