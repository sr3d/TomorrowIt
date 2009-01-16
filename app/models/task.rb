class Task < ActiveRecord::Base
  belongs_to :user
  
  def self.find_active_tasks_for_user( user_id )
    Task.find(:all, 
      :conditions => [ 'user_id = ? AND due_date BETWEEN ? AND ?', 
        user_id,
        Time.now.to_date.to_s(:db),
        1.day.from_now.to_s(:db)
      ] )
  end
  
end
