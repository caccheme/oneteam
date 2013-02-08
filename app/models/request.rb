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
    unless commissions.blank?
      "Developer already selected"
    end
  end

  def qualified_count(employee)
    common_skills1 = list_to_array(relevant_skills) & list_to_array(employee.current_skills)
    count_common_skills(common_skills1)
  end

  def interest_count(employee)
    common_skills2 = list_to_array(relevant_skills) & list_to_array(employee.skills_interested_in)
    count_common_skills(common_skills2)
  end

  def list_to_array(skills)
    skills = skills.split(", ") || []  
  end

  def count_common_skills(array)
    array = array.size || 0
  end

# popularity = case tweet.retweet_count
# when 0..9    then nil
# when 10..99  then "trending"
# else               "hot"
# end  #this does a case method setting the popularity to the method output for different conditionals


  # option[:status] ||= 'Open' #this sets the option to 'open' if it is nil

  # def qualified_count(relevant_skills, current_skills)
  #   common_skills1 = Array.new

  #   if !relevant_skills.nil?
  #     relevant_skills
  #   end
    
  #   if !current_skills.nil?
  #     current_skills
  #   end  

  #   if !relevant_skills.nil? & !current_skills.nil?
  #     common_skills1 = (current_skills & relevant_skills).join(", ")
  #     your_qualified_for = common_skills1.split(", ")
  #     qualified_count = your_qualified_for.size
  #   end

  # end

  # def interest_count(relevant_skills, skills_interested_in) 
  #   common_skills2 = Array.new
    
  #   if !relevant_skills.nil?
  #     relevant_skills = relevant_skills.split(", ")
  #   end
    
  #   if !skills_interested_in.nil?
  #     skills_interested_in = skills_interested_in.split(", ")
  #   end  

  #   if !relevant_skills.nil? & !skills_interested_in.nil?
  #     common_skills2 = (skills_interested_in & relevant_skills).join(", ")
  #     your_interested_in = common_skills2.split(", ")
  #     interest_count = your_interested_in.size
  #   end

  # end  

end