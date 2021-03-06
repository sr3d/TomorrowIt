class ChainTask < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name
  
  def self.find_by_user( user )
    return ChainTask.find( :all, 
      :conditions => [ "is_active = ? AND user_id = ?", true, user.id ],
      :order => 'id ASC' )
  end
  
  def self.find_all_chain_tasks_for_user( user )
    return ChainTask.find( :all, 
      :conditions => [ "user_id = ?", user.id ],
      :order => 'is_active DESC, id DESC ' )        
  end
  
  def load_history_for_month( date )
    return ChainTaskHistory.find( :all, 
      :conditions => [ 'chain_task_id = ? AND created_on >= ? AND created_on < ?', 
        self.id, date.at_beginning_of_month, date.at_beginning_of_month + 1.month
      ])
  end
  
  def toggle_date( date = nil )
    return unless date
    
    if history = ChainTaskHistory.find(:first, :conditions => [ 'created_on = ? AND chain_task_id = ?', date, self.id ])
      history.destroy
    else
      ChainTaskHistory.create!(:chain_task_id => self.id, :user_id => self.user_id, :created_on => date )
    end
  end
  
  def toggle_status!
    self.update_attribute :is_active, !self.is_active
    return self.is_active
  end
  
  def display_color
    return self.color || @@colors[ 0 ]
  end
  
  def before_create
    logger.debug get_next_available_color
    self.color = get_next_available_color if self.color.nil?
  end
  
  @@colors = [ 
    "4096EE", # flock blue
    "FF0084", # flickr pink
    "FF7400", # RSS orangae
    "356AA0", # digg blug
    "D01F3C", # last.fm crimson
    "CC0000", # Rollyo Red
    "C79810", #43 Things Gold
    "D15600", #Etsy Vermillion
    "B02B2C", # ror 
    ]

  def self.colors
    @@colors
  end

  def delete!
    connection.execute "DELETE FROM chain_task_histories WHERE chain_task_id = #{self.id} AND user_id = #{self.user_id}"
    self.destroy
  end
  
  protected
  def get_next_available_color
    count = self.class.count :conditions => [ "user_id = ? ", self.user_id ]
    if( count == 0 ) 
      return @@colors[ 0 ]
    else
      return @@colors[ count % ( @@colors.length - 1 ) ]
    end
  end
  
end
