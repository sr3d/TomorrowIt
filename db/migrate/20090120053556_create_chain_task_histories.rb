class CreateChainTaskHistories < ActiveRecord::Migration
  def self.up
    create_table :chain_task_histories do |t|
      t.column :chain_task_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :created_on, :date
    end
    
    add_index :chain_task_histories, [ :chain_task_id, :created_at ]
    
  end

  def self.down
    drop_table :chain_task_histories
  end
end
