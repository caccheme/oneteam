class CreateDesiredSkills < ActiveRecord::Migration
  def change
    create_table :desired_skills do |t|
      t.integer :skill_id
      t.integer :employee_id
      t.integer :interest

      t.timestamps
    end
 
    DesiredSkill.create :skill_id => 1
    DesiredSkill.create :skill_id => 2
    DesiredSkill.create :skill_id => 3
    DesiredSkill.create :skill_id => 4
    DesiredSkill.create :skill_id => 5
    DesiredSkill.create :skill_id => 6
  end
end
