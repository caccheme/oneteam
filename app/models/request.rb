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

#want to sum up all of the levels that have matching relevant skill only (not all the levels in the array like
# I did first) to get the rating

  # def ability_rating(employee)
  #   array = ability_levels(employee)
  #   array.inject{|sum,x| sum + x }
  # end

  # def interest_rating(employee)
  #   array = interest_levels(employee)
  #   array.inject{|sum,x| sum + x }
  # end

  # def qualified_count(employee)
  #   count_common_skills(relevant_skills, ability_levels(employee))
  # end

  # def interest_count(employee)
  #   count_common_skills(relevant_skills, interest_levels(employee))
  # end

  # def count_common_skills(str1, str2)
  #   common_array = (split_str(str1) & split_str(str2))
  #   common_array.inject{|sum,x| sum + x }
  # end

# these make an array of the ability levels and interest levels of the employee
  # def ability_levels(employee)  
  #   skill_list = skill_list_to_array_of_ids(relevant_skills)
  #   employee.dev_skills.each do |dev_skill, prof|
  #     skill_list.each do |match_skill, level|
  #       if (dev_skill == match_skill) 
  #       return level  
  #       end  
  #     end
  #   end  
  #   return
  # end

  # def interest_levels(employee)  
  #   req_skills = skill_list_to_array_of_ids(relevant_skills)
  #   employee.des_skills.each do |skill, prof|
  #     req_skills.each do |match_skill, level|
  #       if (skill == match_skill) 
  #       return level  
  #       end  
  #     end
  #   end  
  #   return
  # end

#placement of the skills that match to do rating...
  # def skill_list_to_array_of_ids(str) 
  #   array = []
  #   skills = split_str(str)
  #   skills.map do |s|
  #     array = Skill.find_by_language(s).id
  #   end
  #   array
  # end


#need to make the below rating methods find the matching skill in the dev and des skill arrays, pull those levels only, and then 
#add them up to get the ratings
  #  def ability_rating(employee)
  #   array = ability_levels(employee)
  #   array.inject{|sum,x| sum + x }
  # end

  # def interest_rating(employee)
  #   array = interest_levels(employee)
  #   array.inject{|sum,x| sum + x }
  # end

# these make an array of the ability levels and interest levels of the employee
  # def ability_levels(employee) 
  #   ability_rating_array = []
  #   skill_match = list_matching_skills(employee.developer_skills, relevant_skills)
  #   employee.developer_skills.map do |skill, proficiency|
  #     skill_match.each do |s|
  #       if (s == skill.id) 
  #         return proficiency
  #       end    
  #     end  
  #   end
  #   ability_rating_array
  # end

#   def interest_levels(employee)
#     skill_match = list_matching_skills(employee.desired_skills, relevant_skills)
#   end

#   def list_matching_skills(hsh, str)
#     (hash_to_array_of_skills(hsh) & "str".split(",").each { |s| s.to_i })
#   end

# #array of skills to compare to relevant skills
#   def hash_to_array_of_skills (h)
#     h.map { |key, value| key } 
#   end
  
  # def string_to_array_of_skills(str)
  #   "str".split(",").each { |s| s.to_i }
  # end

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

end