class Commission < ActiveRecord::Base
  attr_accessible :comment, :employee_id, :request_id, :response_id, :name
  default_scope order("created_at DESC")  

  belongs_to :response
  has_many :requests, :through => :responses
  has_many :employees, :through => :responses

  accepts_nested_attributes_for :requests, :allow_destroy => true

end
