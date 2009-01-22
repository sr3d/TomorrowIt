class AddIsChainEnabledToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_chain_enabled, :boolean, :default => false
    
    me = User.find(1)
    me.is_chain_enabled = true
    me.save!

  end

  def self.down
    drop_column :users, :is_chain_enabled
  end
end
