class RemoveSkillsFromEmployees < ActiveRecord::Migration
  def up
  	remove_column :employees, :skills_interested_in
  	remove_column :employees, :current_skills
  end

  def down
  	add_column :employees, :skills_interested_in, :string
  	add_column :employees, :current_skills, :string
  end
end