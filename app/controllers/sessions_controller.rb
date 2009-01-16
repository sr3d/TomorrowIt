# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      log_user_in( user )
      
      respond_to do |format|
        format.html do
          redirect_back_or_default('/')
        end
        format.js do 
          render :update do |page|
            page << 'location.reload();'
          end
        end
      end
      
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      
      respond_to do |format|
        
        format.html do
          render :action => 'new'
        end
        
        format.js do 
          render :update do |page|
            page << "showForgotPassword();"
            page << 'Effect.Shake("btnLogin", {duration: 0.3, distance: 2});'
          end
        end # format
        
      end # respond to
      
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
