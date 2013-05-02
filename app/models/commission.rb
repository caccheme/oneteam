class Commission < ActiveRecord::Base
  attr_accessible :comment, :employee_id, :request_id, :response_id, :name, :created_at
  default_scope order("created_at DESC")  

  belongs_to :response
  
  has_many :requests, :through => :responses
  
  has_one :employee, :through => :response
  has_one :reward
  accepts_nested_attributes_for :reward  
end
