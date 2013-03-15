class AddLevelToDeveloperSkills < ActiveRecord::Migration
  def change
    add_column :developer_skills, :level, :integer, :default => 3
  end
end
