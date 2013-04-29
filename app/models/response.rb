class Response < ActiveRecord::Base
  attr_accessible :comment, :response_id, :employee_id, :employee_name 
  belongs_to :request
  belongs_to :employee
  
  has_one :commission
  accepts_nested_attributes_for :commission, :allow_destroy => true

  validates_presence_of :comment, :employee_id

 end
