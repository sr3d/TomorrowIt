class CreateAdminAccount < ActiveRecord::Migration
  def self.up
    u = User.new  :login => 'sr3d', 
                  :password => 'abc123', 
                  :password_confirmation => 'abc123',
                  :email => 'nworld3d@yahoo.com'
    u.is_admin = 1
    u.save!
  end

  def self.down
  end
end
