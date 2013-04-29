class Reward < ActiveRecord::Base
  attr_accessible :commission_id, :reward_date, :evaluations_attributes
  
  has_many :evaluations
  
  belongs_to :commission
  belongs_to :response

  accepts_nested_attributes_for :evaluations, :allow_destroy => true

  def find_number_of_days(request_id)
    start_date = Request.find_by_id(request_id).start_date
    end_date = Request.find_by_id(request_id).end_date
      (end_date.to_date - start_date.to_date).to_i
  end	

  def days_array(days)
    (0..days).each do |day|
    end
  end

end