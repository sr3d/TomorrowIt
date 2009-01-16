class Task < ActiveRecord::Base
  belongs_to :user
  
  before_create :set_due_date
  
  def self.find_active_tasks_for_user( user_id )
    Task.find(:all, 
      :conditions => [ 'user_id = ? AND due_date BETWEEN ? AND ?', 
        user_id,
        Time.now.to_date.to_s(:db),
        1.day.from_now.to_s(:db)
      ] )
  end
  
  
  def self.find_temp_tasks( task_ids )
    return [] if task_ids.nil? or task_ids.empty?
    Task.find(:all, 
      :conditions => [ '( user_id IS NULL AND id IN (?) ) AND due_date BETWEEN ? AND ? ', 
        task_ids,
        Time.now.to_date.to_s(:db),
        1.day.from_now.to_s(:db)
      ] )    
  end
  
  
  def set_due_date( due_date = nil )
    self.due_date = due_date.nil? ? 1.day.from_now : due_date
  end
  
end
