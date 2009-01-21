class ChainTaskHistory < ActiveRecord::Base
  belongs_to :chain_task
  belongs_to :user
  
  def get_date
    self.created_on
  end
  
  def get_type_id
    self.chain_task_id
  end
  
end
