class Skill < ActiveRecord::Base
  attr_accessible :language
  has_and_belongs_to_many :employees
  belongs_to :employee
  belongs_to :requests

  has_many :employees, :through => :developer_skills
  has_many :employees, :through => :desired_skills
  has_many :evaluations
end
