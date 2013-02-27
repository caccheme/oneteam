class Request < ActiveRecord::Base
  attr_accessible :description, :status, :start_date, :end_date, :employee_id, :title, :relevant_skills, :location, :group
  belongs_to :employee
  default_scope order("created_at DESC")  

  has_many :responses, :dependent => :destroy
  accepts_nested_attributes_for :responses, :allow_destroy => true

  has_many :request_skills
  accepts_nested_attributes_for :request_skills

  has_many :commissions, :through => :responses
  belongs_to :commission

#still need this skill association?
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

  def qualified_count(employee)  
    count_common_skills(relevant_skills, employee.developer_skills)
  end

  def interest_count(employee)
    count_common_skills(relevant_skills, employee.desired_skills)
  end

  def count_common_skills(str1, str2)
    (split_str(str1) & split_str(str2)).length
  end

  def split_str(str)
    str.split(", ") || []
  end

  def end_date_cannot_be_before_start_date
    if !end_date.nil? and start_date > end_date
      errors.add(:end_date, "can't be before start date")
    end
  end




# popularity = case tweet.retweet_count
# when 0..9    then nil
# when 10..99  then "trending"
# else               "hot"
# end  #this does a case method setting the popularity to the method output for different conditionals, perhaps use later on ratings?

# option[:status] ||= 'Open' #this sets the option to 'open' if it is nil

end