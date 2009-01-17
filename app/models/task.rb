class Task < ActiveRecord::Base
  belongs_to :user
  
  before_create :set_due_date
  
  def self.find_active_tasks_for_user( user_id )
    Task.find(:all, 
      :conditions => [ 'user_id = ? AND due_date >= ? AND due_date < ?', 
        user_id,
        Time.now.to_date,
        Time.now.to_date + 2
      ] )
  end
  
    
  def self.find_temp_tasks( task_ids )
    return [] if task_ids.nil? or task_ids.empty?
    Task.find(:all, 
      :conditions => [ 
        '( user_id IS NULL AND id IN (?) ) AND ( due_date >= ? AND due_date < ? )
          AND done_date IS NULL', 
        task_ids,
        Time.now.to_date,
        Time.now.to_date + 2
      ],
      :order => 'created_at DESC'  )
  end
  
  
  def set_due_date( due_date = nil )
    self.due_date = due_date.nil? ? ( Time.now.to_date + 1 ) : due_date.to_date
  end
  
  def done!
    self.done_date = Time.now.to_date
    self.save!
  end
  
end
