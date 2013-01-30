class Employee < ActiveRecord::Base
  has_secure_password

  attr_protected :password_salt, :password_hash 
  attr_accessible :employee_id, :password, :password_confirmation, :department, :email, :group, :location, :manager, :first_name, :last_name, :description, :position, :current_skills, :skills_interested_in, :years_with_company, :image

  before_save :encrypt_password

  has_many :requests, dependent: :destroy
  belongs_to :request

  has_many :responses, :through => :requests
  has_many :commissions, :through => :responses
  
  accepts_nested_attributes_for :requests
  accepts_nested_attributes_for :responses

  has_and_belongs_to_many :skills
  belongs_to :skills   

  mount_uploader :image, ImageUploader
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates :password, :length => { :in => 5..20 }, :on => :create
  validates_presence_of :email, :first_name, :last_name  
  validates_uniqueness_of :email, :first_name and :last_name

  before_create { generate_token(:auth_token) }

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    EmployeeMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Employee.exists?(column => self[column])
  end

  def self.authenticate(email, password)
    employee = find_by_email(email)
    if employee && employee.password_hash == BCrypt::Engine.hash_secret(password, employee.password_salt)
      employee
    else
      nil
    end
  end      

  def encrypt_password
  	if password.present?
  		self.password_salt = BCrypt::Engine.generate_salt
  		self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  	end	
  end

end
