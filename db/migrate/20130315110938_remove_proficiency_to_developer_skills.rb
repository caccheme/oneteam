class RemoveProficiencyToDeveloperSkills < ActiveRecord::Migration
  def up
  	remove_column :developer_skills, :proficiency
  end

  def down
  	add_column :developer_skills, :proficiency, :integer
  end
end
