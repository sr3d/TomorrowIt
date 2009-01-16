class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  def show
    
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save && @user.errors.empty?
    
    if success 
      # log user in
      log_user_in @user
      # save anonymous items
      
    end
    
    respond_to do |format|
      format.js do 
        if success 
          flash[:notice] = "Thanks for signing up"
          render :update do |page|
            page << "location.reload(true);"
          end
        else
          render :update do |page|
            msg = ''
            @user.errors.each { |attribute, error | msg += "#{attribute} #{error} \\n"}
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
      
    end #respond
  end

  
  def forgot_password
    
  end
  

end
