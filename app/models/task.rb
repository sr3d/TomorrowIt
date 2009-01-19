class Task < ActiveRecord::Base
  belongs_to :user
  
  before_create :set_due_date
  
  def self.find_active_tasks_for_user( user_id )
    Task.find(:all, 
      :conditions => [ 'user_id = ? AND due_date >= ? AND due_date < ? AND done_date IS NULL', 
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
        Time.now.to_date + 2 ],
      :order => 'created_at DESC'  )
  end
  
  def self.find_tasks_for_date( user, due_date )
    return Task.find( :all ,
      :conditions => [ 
        'user_id = ? AND ( due_date >= ? AND due_date < ? ) AND done_date IS NULL',
        user.id, due_date, due_date + 1
    ] )
  end
  
  def self.associate_temp_tasks_to_user( task_ids, user )
    task_ids ||= []
    return if task_ids.empty? or user.new_record?
    
    task_ids = task_ids.collect{ |task_id| ActiveRecord::Base.sanitize( task_id.to_i ) }.join(',')
    self.connection.execute(
      %!UPDATE tasks 
      SET user_id = #{user.id},  updated_at = NOW() 
      WHERE id IN ( #{ task_ids } ) AND user_id IS NULL!
    )
  end
  
  def self.find_tasks_by_token( token = nil )
    return [] if token.nil? or token.strip.blank?
    Task.find_by_sql [
      "SELECT t.* 
      FROM tasks t
      INNER JOIN users u ON u.id = t.user_id 
      WHERE token = ? AND due_date >= ? AND due_date < ? AND done_date IS NULL", 
      token , Time.now.to_date, Time.now.to_date + 2.days ]
  end
  
  def self.count_all_today_tasks
    Task.count :conditions => "due_date = CURDATE()"
  end
  
  def self.count_all_tomorrow_tasks
    Task.count :conditions => "due_date = ADDDATE(CURDATE(), 1)"
  end
  
  def set_due_date( due_date = nil )
    self.due_date = due_date.nil? ? ( Time.now.to_date + 1 ) : due_date.to_date
  end
  
  def done!
    self.done_date = Time.now.to_date
    self.save!
  end
  
  def to_ical
    event = Icalendar::Event.new
    event.dtstart  = self.due_date.to_date
    event.summary  = "#{self.name} (#{self.description})"
    return event    
  end
  
  
end
