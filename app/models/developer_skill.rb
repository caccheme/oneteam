class DeveloperSkill < ActiveRecord::Base
  attr_accessible :employee_id, :proficiency, :skill_id

  belongs_to :employee
end
