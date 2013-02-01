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
    if end_date < Date.today
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

#   def employee_already_applied?
#     responses = get_responses
#     responses.each do |response|
#       if response.employee_id == helpers.current_employee.id 
#         true
#       end
#     end  
#   end  

# def helpers
#   ApplicationController.helpers
# end


  # def cancel_status? 
  #   if status_text == 'Cancelled'  
  #     "Cancelled" 
  #   else 
  #     commissions =get_commissions
  #       if commission.blank? 
  #         "Active"  
  #         link_to 'Cancel', edit_request_path(request.id) 
  #       end 
  #   end
  # end 

end