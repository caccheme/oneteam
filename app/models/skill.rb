class Skill < ActiveRecord::Base
  attr_accessible :language
  has_and_belongs_to_many :employees
  belongs_to :employees
  belongs_to :requests
end
