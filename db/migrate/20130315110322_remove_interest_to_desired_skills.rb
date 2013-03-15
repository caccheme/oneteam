class RemoveInterestToDesiredSkills < ActiveRecord::Migration
  def up
  	remove_column :desired_skills, :interest
  end

  def down
  	add_column :desired_skills, :interest, :integer
  end
end
