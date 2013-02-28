class DesiredSkill < ActiveRecord::Base
  attr_accessible :employee_id, :interest, :skill_id

  belongs_to :employee
  belongs_to :skill
end
