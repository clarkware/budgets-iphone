class User < ActiveRecord::Base
  
  has_many :budgets
  
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password
  
  before_create :prepare_password
  
  validates_presence_of :username, :email
  validates_format_of :email, :with => /(\S+)@(\S+)/
  validates_uniqueness_of :username, :email

  validates_presence_of :password, :on => :create
  validates_length_of   :password, :minimum => 4
  validates_confirmation_of :password
  
  def self.authenticate(login, password)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.matching_password?(password)
  end
  
  def matching_password?(password)
    self.password_hash == encrypt_password(password)
  end
  
private
  
  def prepare_password
    self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
    self.password_hash = encrypt_password(password)
  end
  
  def encrypt_password(password)
    Digest::SHA1.hexdigest([password, password_salt].join)
  end
  
end