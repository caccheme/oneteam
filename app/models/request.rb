class Request < ActiveRecord::Base
  attr_accessible :description, :status, :start_date, :end_date, :employee_id, :title, :relevant_skills, :location, :group
  belongs_to :employee
  default_scope order("created_at DESC")  

  has_many :responses, :dependent => :destroy
  accepts_nested_attributes_for :responses, :allow_destroy => true

  has_many :commissions, :through => :responses
  belongs_to :commission

  has_and_belongs_to_many :skills
  belongs_to :skills

  validates_presence_of :title
  validates :description, :length => { :in => 5..200 }
  validate :check_request_dates

  def get_responses
    Response.where(:request_id => id)
  end

  def get_commissions
    Commission.where(:request_id => id)
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

  def check_request_dates
    if start_date.nil?
       errors.add(:start_date, "required")
    elsif end_date.nil?
       errors.add(:end_date, "required")  
    elsif end_date < Date.today
       errors.add(:end_date, "can only be later than today")
    elsif start_date > end_date
       errors.add(:start_date, "needs to be before end date")
    end
  end

  def status_text 
    if status.nil?
      project_status
    else 
      status 
    end 
  end

  def already_assigned?
    if !commissions.blank?
      "Developer already selected"
    end
  end

  def qualified_count(relevant_skills, current_skills)
    common_skills1 = Array.new

    if !relevant_skills.nil?
      relevant_skills = relevant_skills.split(", ")
    end
    
    if !current_skills.nil?
      current_skills = current_skills.split(", ")
    end  

    if !relevant_skills.nil? & !current_skills.nil?
      common_skills1 = (current_skills & relevant_skills).join(", ")
      your_qualified_for = common_skills1.split(", ")
      qualified_count = your_qualified_for.size
    # elsif current_skills.nil?
    #   "You have not yet filled in your current skills on your profile."
    # elsif relevant_skills.nil?
    #   "This request does not have any required skills listed"
    end

  end

  def interest_count(relevant_skills, skills_interested_in) 
    common_skills2 = Array.new
    
    if !relevant_skills.nil?
      relevant_skills = relevant_skills.split(", ")
    end
    
    if !skills_interested_in.nil?
      skills_interested_in = skills_interested_in.split(", ")
    end  

    if !relevant_skills.nil? & !skills_interested_in.nil?
      common_skills2 = (skills_interested_in & relevant_skills).join(", ")
      your_interested_in = common_skills2.split(", ")
      interest_count = your_interested_in.size
    # elsif skills_interested_in.nil?
    #   "You have not yet filled in skills you are interested in on your profile."
    # elsif relevant_skills.nil?
    #   "This request does not have any required skills listed."  
    end

  end  

end