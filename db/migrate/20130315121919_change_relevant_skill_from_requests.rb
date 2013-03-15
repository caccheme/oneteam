class ChangeRelevantSkillFromRequests < ActiveRecord::Migration
  def up
  	remove_column :requests, :relevant_skills
  	add_column :requests, :relevant_skill, :string
  end

  def down
  	add_column :requests, :relevant_skills, :string
  	remove_column :requests, :relevant_skill
  end
end