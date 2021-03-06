require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken


  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  before_create :make_activation_code 
  
  before_create :make_token

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  has_many :tasks
  has_many :chain_tasks
  has_many :chain_task_histories


  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    true
  end
  
  def new_token!
    make_token
    save!
  end
  
  
  def reset_password!
		length = 10
    chars = ("a".."z").to_a + ("1".."9").to_a 
		new_password = Array.new( length , '').collect{ chars[ rand(chars.size) ] }.join
		self.password = new_password
		self.password_confirmation = new_password
		save!
		
		notify :after_reset_password
		
		return true
  end
  
  def toggle_chain_task_feature!
    self.update_attribute :is_chain_enabled, !self.is_chain_enabled
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? ', login]
    u && u.authenticated?(password) ? u : nil
  end

  protected
    
    def make_activation_code
      self.activation_code = self.class.make_token
    end
    
    # populate the security token
    def make_token
      self.token = self.class.make_token
    end

end
