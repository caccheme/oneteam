class Employee < ActiveRecord::Base
  has_secure_password

  attr_protected :password_salt, :password_hash 
  attr_accessible :employee_id, :password, :password_confirmation, :department, :email, :group, :location, :manager, :first_name, :last_name, :description, :position, :years_with_company, :image, :developer_skills, :desired_skills, :dev_skills, :des_skills, :skills

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

  has_many :developer_skills
  has_many :desired_skills

  accepts_nested_attributes_for :desired_skills
  accepts_nested_attributes_for :developer_skills
  
  #virtual attributes for new skill resources
  def dev_skills
    h = {}
    self.developer_skills.each do |dev_skill|
      h[dev_skill.skill_id] = dev_skill.proficiency
    end
  end

  def dev_skills= h
    new_dev_skills = []
    h.each do |skill_id, proficiency| 
      new_dev_skills << DeveloperSkill.new(skill_id: skill_id, proficiency: proficiency) 
    end
    self.developer_skills = new_dev_skills 
  end

  def des_skills
    h = {}
    self.desired_skills.each do |des_skill|
      h[des_skill.skill_id] = des_skill.interest
    end
  end

  def des_skills= h
    new_des_skills = []
    h.each do |skill_id, interest| 
      new_des_skills << DesiredSkill.new(skill_id: skill_id, interest: interest) 
    end
    self.desired_skills = new_des_skills
  end



  # def has_skill_level? (skill, n)
  #   dev_skills.map do |s|
  #     if s.id == skill && s.proficiency == n
  #       true
  #     else
  #      false
  #     end
  #   end
  # end

#   def has_skill_level? (skill, n)
# # loop through dev_skill check for dev skill that == skill && n

#     dev_skills.include?(n)
#   end

  # def has_skill_level? (skill, n)
  #   DeveloperSkill.find(skill)
  #     if dev_skills.include?(skill) 
  #       proficiency = n
  #     end
  # end

  def has_skill_level? (skill, n)
    dev_skills.each do |s|
      if s.id == skill && s.proficiency == n
        return s.id && s.proficiency
      else
        false
      end
    end
    return []
  end

  def wants_skill_level? (skill, n)
    des_skills.each do |s|
      if s.id == skill && s.interest == n
      else
        false
      end
    end
  end

end