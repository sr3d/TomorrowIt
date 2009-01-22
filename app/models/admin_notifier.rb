class AdminNotifier < ActionMailer::Base
  
  @url  = "http://tomrrowit.com"
  
  def daily_summary()
    setup_email
    
    @subject    += " - #{@yesterday.strftime('%m.%D.%Y') } Summary"
    @body[:new_users_count] = User.count( :conditions => [ 'created_at >= ? AND created_at < ?', @yesterday, @today ] ) || 0
    @body[:new_tasks_count] = User.count( :conditions => [ 'created_at >= ? AND created_at < ?', @yesterday, @today ] ) || 0
    @body[:new_task_marked_as_done] = Task.count( :conditions => [ 'done_date >= ? AND done_date < ?', @yesterday, @today ] ) || 0
    @body[:new_chain_tasks_count] = ChainTask.count :conditions => [ 'created_at >= ? AND created_at < ?', @yesterday, @today ] || 0
    
    
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
    def setup_email()
      @recipients  = "nworld3d@yahoo.com"
      @from        = "no-reply@tomorrowit.com"
      @subject     = "TomorrowIt Admin"
      @sent_on     = Time.now
      
      @body[:yesterday] = @yesterday = Time.now.yesterday.to_date
      @body[:today]     = @today     = Time.now.to_date
    end

end
