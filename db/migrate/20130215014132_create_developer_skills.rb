class CreateDeveloperSkills < ActiveRecord::Migration
  def change
    create_table :developer_skills do |t|
      t.integer :skill_id
      t.integer :employee_id
      t.integer :proficiency

      t.timestamps
    end

    DeveloperSkill.create :skill_id => 1
    DeveloperSkill.create :skill_id => 2
    DeveloperSkill.create :skill_id => 3
    DeveloperSkill.create :skill_id => 4
    DeveloperSkill.create :skill_id => 5
    DeveloperSkill.create :skill_id => 6  

  end
end
