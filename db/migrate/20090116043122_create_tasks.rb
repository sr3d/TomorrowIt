class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column :user_id, :integer
      t.column :name, :string, :limit => 255, :null => false
      t.column :due_date, :datetime
      t.column :done_date, :datetime
      t.column :is_important, :boolean, :default => false
      t.column :description, :text
      t.timestamps
    end
    
    add_index :tasks, [ :user_id, :due_date ]
    
  end

  def self.down
    drop_table :tasks
  end
end
