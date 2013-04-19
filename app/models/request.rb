class Request < ActiveRecord::Base
  attr_accessible :description, :status, :start_date, :end_date, :employee_id, :title, :relevant_skill, :location, :group
  belongs_to :employee
  default_scope order("created_at DESC")  

  has_many :responses, :dependent => :destroy
  accepts_nested_attributes_for :responses, :allow_destroy => true

  has_many :commissions, :through => :responses
  belongs_to :commission

  has_and_belongs_to_many :skills
  belongs_to :skills

  has_one :commission
  has_many :rewards
  has_many :evaluations
  accepts_nested_attributes_for :evaluations


  validates_presence_of :title, :start_date, :end_date
  validates :description, :length => { :in => 5..200 }
  validate :end_date_cannot_be_before_start_date

  def get_responses
    Response.where(:request_id => id)
  end

  def get_commissions
    Commission.where(:request_id => id)
  end

  def status_text 
    if status.nil?
      project_status
    else 
      "Cancelled" 
    end 
  end

  def project_status 
    if status == 'Cancelled'
      "Cancelled"
    elsif end_date <= Date.today 
      "Closed, Completed"
    elsif end_date <= Date.today 
      "Expired"   
    elsif start_date <= Date.today 
      "Open, In progress"
    elsif start_date >= Date.today 
      "Open, Not Started"  
    elsif start_date >= Date.today   
      "Assigned"
    end
  end 

  def already_assigned?
    unless commissions.blank?
      "Developer already selected"
    end
  end

  def end_date_cannot_be_before_start_date
    if !end_date.nil? and start_date > end_date
      errors.add(:end_date, "can't be before start date")
    end
  end

  def match_skills(employee)
    skill_score = []
    relevant_skills = relevant_skill.split(", ")
    skill_length = relevant_skills.length
    x = 0
    while x < skill_length
      skill_id = Skill.find_by_language(relevant_skills.slice(x)).id
      developer_skills = DeveloperSkill.find_all_by_employee_id(employee.id)
      developer_skills.each do |dev_id|
        if dev_id.skill_id == skill_id
          skill_score.push(dev_id.level)
          break
        end
      end
      x = x + 1
    end
    skill_score.sum
  end

  def match_desired_skills(employee)
    skill_score = []
    relevant_skills = relevant_skill.split(", ")
    skill_length = relevant_skills.length
    x = 0
    while x < skill_length
      skill_id = Skill.find_by_language(relevant_skills.slice(x)).id
      desired_skills = DesiredSkill.find_all_by_employee_id(employee.id)
      desired_skills.each do |des_id|
        if des_id.skill_id == skill_id
          skill_score.push(des_id.level)
          break
        end
      end
      x = x + 1
    end
    skill_score.sum
  end

#old rating methods
  def qualified_count(employee)
    count_common_skills(relevant_skills, employee.current_skills)
  end

  def interest_count(employee)
    count_common_skills(relevant_skills, employee.skills_interested_in)
  end

  def count_common_skills(str1, str2)
    (split_str(str1) & split_str(str2)).length
  end

  def split_str(str)
    str.split(", ") || []
  end

  def duration_in_days
    (end_date.to_date - start_date.to_date).to_i
  end 

end