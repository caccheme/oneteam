class DeveloperSkill < ActiveRecord::Base
  attr_accessible :employee_id, :level, :skill_id, :language

  belongs_to :employee
  belongs_to :skill
  has_and_belongs_to_many :employees
  has_many :skills
  has_many :employees
end