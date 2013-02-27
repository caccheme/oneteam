class CreateRequestSkills < ActiveRecord::Migration
  def change
    create_table :request_skills do |t|
      t.integer :skill_id
      t.integer :request_id

      t.timestamps
    end

    RequestSkill.create :skill_id => 1
    RequestSkill.create :skill_id => 2
    RequestSkill.create :skill_id => 3
    RequestSkill.create :skill_id => 4
    RequestSkill.create :skill_id => 5
    RequestSkill.create :skill_id => 6
  end
end
