class Employee < ActiveRecord::Base
  has_secure_password
  attr_protected :password_salt, :password_hash 
  attr_accessible :employee_id, :password, :password_confirmation, :department_id, :email, :group_id 
  attr_accessible :location_id, :manager, :first_name, :last_name, :description, :position_id
  attr_accessible :years_with_company, :image, :current_skills, :developer_skills, :desired_skills, :dev_skills, :des_skills
  attr_accessible :skills, :skills_interested_in

  before_save :encrypt_password
  before_save { |employee| employee.email = email.downcase }

  has_many :requests, dependent: :destroy
  
  has_many :responses
  has_many :commissions, :through => :responses
  accepts_nested_attributes_for :requests
  accepts_nested_attributes_for :responses

  has_many :departments
  belongs_to :location
  belongs_to :group
  belongs_to :department
  belongs_to :position

  has_and_belongs_to_many :skills
  attr_accessor :current_skills
  attr_accessor :skills_interested_in
  has_many :developer_skills
  has_many :desired_skills
  has_many :rewards, :through => :commission
  has_many :evaluations

  belongs_to :skill
  belongs_to :commission
  accepts_nested_attributes_for :skills
  accepts_nested_attributes_for :desired_skills
  accepts_nested_attributes_for :developer_skills
  accepts_nested_attributes_for :rewards

  mount_uploader :image, ImageUploader
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates :password, :length => { :in => 5..20 }, :on => :create
  validates_presence_of :email, :first_name, :last_name  

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

  def wants_skill_level(skill_id, level)
    desired_skills.each do |dev_id|
      return true if dev_id.skill_id == skill_id && dev_id.level == level
    end      
    level == 0
  end

  def new_skill_level(skill_id, level)
    level == 3
  end 

  def total_evaluations(skill)
    sum = 0
    if !self.responses.nil?
      self.responses.each do |response|
        if !response.commission.reward.evaluations.nil?
          response.commission.reward.evaluations.each do |eval| 
            if eval.skill_id == skill.id
              sum += eval.eval_number
            end  
          end        
        end
      end
    end  
    sum    
  end

  def average_skill_level(skill)
    eval_counter = 0
    sum = 0
    if !self.responses.nil?
      self.responses.each do |response|
        if !response.commission.reward.evaluations.nil?
          response.commission.reward.evaluations.each do |eval| 
            if eval.skill_id == skill.id && eval.eval_number != 0
              sum += eval.level
              eval_counter += 1         
            end    
          end        
        end
      end
      if eval_counter == 0 
        "n/a"
      else
        sum/eval_counter
      end
    end  
  end

  def award_skills(response)
  reward_skill = []
  response.commission.reward.evaluations.each do |evaluation|
    if evaluation.eval_number != 0
      reward_skill.push(evaluation.eval_number)
    end
  end
    if !reward_skill.nil?
      reward_skill.join(", ")
    end
  end

  def view_rewards(commission)
    reward_skill = []
    commission.reward.evaluations.each do |evaluation|
      if evaluation.eval_number != 0
        language = evaluation.skill.language 
        reward_skill.push(language)
        reward_skill.push(evaluation.eval_number)
      end
    end
    reward_skill.join(", ")
  end

  def desired_skill_level(skill_id, level)
      desired_skills.each do |dev_id|
        return true if dev_id.skill_id == skill_id && dev_id.level == level
      end
      level == 0
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

  def evaluation_check
    commissions.each do |commission|
      return true if !commission.response.employee.reward.nil?
    end
  end

  def show_dev_skill_and_level
    skillname = []
      developer_skills.each do |dev_skill|
        if dev_skill.level != 0 
        language = dev_skill.skill.language 
        level = dev_skill.level
        skillname.push(language)
        skillname.push(level)
        end
      end
    skillname.join(", ")
 end

  def show_des_skill_and_level
    skillname = []
      desired_skills.each do |des_skill|
        if des_skill.level != 0 
        language = des_skill.skill.language
        level = des_skill.level
        skillname.push(language)
        skillname.push(level)
        end
      end
    skillname.join(", ")
  end

end