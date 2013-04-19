class Commission < ActiveRecord::Base
  attr_accessible :comment, :employee_id, :request_id, :response_id, :name
  default_scope order("created_at DESC")  

  belongs_to :response
  
  has_one :employee, :through => :response
  has_one :reward
  
end
