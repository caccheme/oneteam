class Employee < ActiveRecord::Base
  has_secure_password
  attr_protected :password_salt, :password_hash 
  attr_accessible :employee_id, :password, :password_confirmation, :department, :email, :group, :location, :manager, :first_name, :last_name, :description, :position, :years_with_company, :image, :current_skills, :developer_skills, :desired_skills, :dev_skills, :des_skills, :skills, :skills_interested_in

  before_save :encrypt_password
  before_save { |employee| employee.email = email.downcase }

  has_many :requests, dependent: :destroy
  belongs_to :request
  has_many :responses, :through => :request
  has_many :commissions, :through => :responses
  accepts_nested_attributes_for :requests
  accepts_nested_attributes_for :responses

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
  validates_uniqueness_of :email, :first_name and :last_name
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX } ,
            uniqueness: { case_sensitive: false }

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

# still need thiss new skill level??

  def new_skill_level(skill_id, level)
    level == 3
  end 

  def average_eval(skill)
    average_evaluation = 0
    eval_counter = 0
    commissions.each do |commission|
      if !commission.reward.evaluations.nil?
        commision.reward.evaluations.each do |evaluation|
          if evaluation.skill_id == skill.id && evaluation.eval_number != 0
            average_evaluation += evaluation.eval_number
            eval_counter += 1
          end
        end
      end
    end
    average_evaluation/eval_counter
  end

  def award_skills(response)
  reward_skill = []
  response.commission.reward.evaluations.each do |evaluation|
    if evaluation.eval_number != 0
      language = evaluation.skill.language
      reward_skill.push(language)
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
        language = Skill.find(evaluation.skill_id).language
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

  def total_evaluations(skill)
    total_evaluation = 0
      commissions.each do |commission|
        if !commission.reward.evaluations.nil?
          commission.reward.evaluations.each do |evaluation|
            if evaluation.skill_id == skill.id
              total_evaluation += evaluation.eval_number
            end
          end
        end
      end
      total_evaluation
  end

  def current_skills=(current_skills)
    self.developer_skills = to_developer_skills current_skills
  end

  def skills_interested_in=(skills_interested_in)
    self.desired_skills = to_desired_skills skills_interested_in
  end

  def evaluation_check
    commissions.each do |commission|
      return true if !commission.reward.evaluations.nil?
    end
  end

end