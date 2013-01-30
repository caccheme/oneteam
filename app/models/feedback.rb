class Feedback < ActiveRecord::Base
  attr_accessible :comment, :name

  belongs_to :employee
end
