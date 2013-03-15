class Employee < ActiveRecord::Base
  has_secure_password
  attr_protected :password_salt, :password_hash 
  attr_accessible :employee_id, :password, :password_confirmation, :department, :email, :group, :location, :manager, :first_name, :last_name, :description, :position, :years_with_company, :image, :current_skills, :developer_skills, :desired_skills, :dev_skills, :des_skills, :skills, :skills_interested_in

  before_save :encrypt_password

  has_many :requests, dependent: :destroy
  belongs_to :request
  has_many :responses, :through => :requests
  has_many :commissions, :through => :responses
  accepts_nested_attributes_for :requests
  accepts_nested_attributes_for :responses

  has_and_belongs_to_many :skills
  attr_accessor :current_skills
  attr_accessor :skills_interested_in
  has_many :developer_skills
  has_many :desired_skills
  belongs_to :skills
  accepts_nested_attributes_for :skills
  accepts_nested_attributes_for :desired_skills
  accepts_nested_attributes_for :developer_skills

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


  def has_skill_level(skill_id, level)
    developer_skills.each do |dev_id|
      return true if dev_id.skill_id == skill_id && dev_id.level == level
    end 
    level == 0
  end

  # def has_skill_level? (skill, level) my original method
  #   dev_skills.each do |s, p|
  #     if (s == skill.id) && (p == level)
  #       return level    
  #     end  
  #   end
  #   nil
  # end

  def wants_skill_level(skill_id, level)
    desired_skills.each do |dev_id|
      return true if dev_id.skill_id == skill_id && dev_id.level == level
    end      
    level == 0
  end

  # def wants_skill_level? (skill, level) my original method
  #   des_skills.each do |s, i|
  #     if (s == skill.id) && (i == level)
  #       return level 
  #     end
  #   end
  #   nil
  # end

  def new_skill_level(skill_id, level)
    level == 3
  end 

  def to_developer_skills(current_skills)
    if !current_skills.nil?
      developer_skills = []
      current_skills.each do |skill, level|
        if level != "0"
          developer_skill = DeveloperSkill.new( :skill_id => skill, :level => level)
          developer_skills = developer_skills.push(developer_skill)
        end
      end
      developer_skills
    end
  end

  def to_desired_skills(skills_interested_in)
    if !skills_interested_in.nil?
      desired_skills = []
      skills_interested_in.each do |skill, level|
        if level != "0"
          desired_skill = DesiredSkill.new( :skill_id => skill, :level => level)
          desired_skills = desired_skills.push(desired_skill)
        end
      end
      desired_skills
    end
  end

  def current_skills=(current_skills)
    self.developer_skills = to_developer_skills current_skills
  end

  def skills_interested_in=(skills_interested_in)
    self.desired_skills = to_desired_skills skills_interested_in
  end

  #virtual attributes for new skill resources
  # def dev_skills
  #   h = {}
  #   self.developer_skills.each do |dev_skill|
  #     h[dev_skill.skill_id] = dev_skill.proficiency
  #   end
  #   h
  # end

  # def dev_skills= h
  #   new_dev_skills = []
  #   h.each do |skill_id, proficiency| 
  #     new_dev_skills << DeveloperSkill.new(skill_id: skill_id, proficiency: proficiency) 
  #   end
  #   self.developer_skills = new_dev_skills 
  # end

  # def des_skills
  #   h = {}
  #   self.desired_skills.each do |des_skill|
  #     h[des_skill.skill_id] = des_skill.interest
  #   end
  #   h
  # end

  # def des_skills= h
  #   new_des_skills = []
  #   h.each do |skill_id, interest| 
  #     new_des_skills << DesiredSkill.new(skill_id: skill_id, interest: interest) 
  #   end
  #   self.desired_skills = new_des_skills
  # end

end