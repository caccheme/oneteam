class AddLevelToDesiredSkills < ActiveRecord::Migration
  def change
    add_column :desired_skills, :level, :integer, :default => 3
  end
end
