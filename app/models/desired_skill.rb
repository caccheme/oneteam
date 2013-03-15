class DesiredSkill < ActiveRecord::Base
  attr_accessible :employee_id, :level, :skill_id, :language

  belongs_to :employee
  belongs_to :skill
end