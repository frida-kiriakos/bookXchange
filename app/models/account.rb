class Account < ActiveRecord::Base
  validates :name, presence: true, length: {maximum: 50}

  # a unique index will be created for the email to validate uniqueness on the database level
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[csu\.]*fullerton\.edu\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX, message: ": Please enter a valid CSUF email address, @csu.fullerton.edu or @fullerton.edu"}, uniqueness: { case_sensitive: false }

  # validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }
  
  #if we don't need to confirm the password, just comment the line below
  
  validates :password_confirmation, presence: true

  has_many :books  
  has_many :transactions

  has_one :profile

  before_save { |account| account.email = email.downcase }
  before_save :create_remember_token

  private
  
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
