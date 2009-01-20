class CreateChainTasks < ActiveRecord::Migration
  def self.up
    create_table :chain_tasks do |t|
      t.column :name, :string, :limit => 250, :null => false
      t.column :user_id, :integer, :null => false
      t.column :color, :string, :limit => 30
      t.column :is_active, :boolean, :null => false, :default => true
      t.timestamps
    end
    
    add_index :chain_tasks, [ :user_id ]
    
  end

  def self.down
    drop_table :chain_tasks
  end
end
