class UserMailer < ActionMailer::Base
  @url  = "www.http://tomrrowit.com"
  
  def signup_notification(user)
    setup_email(user)
    @subject    += ' - Start Tomorrowing Your Day'
    body[:url]  = @url
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://tomorrowit.com/"
  end

  def password_reset( user )
    setup_email user
    @subject      += "- Password Reset"
    @body[:url]   = @url
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-reply@tomorrowit.com"
      @subject     = "TomorrowIt "
      @sent_on     = Time.now
      @body[:user] = user
    end

end
