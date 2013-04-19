class RemovecolumnsFromRewards < ActiveRecord::Migration
  def up
  	remove_column :rewards, :skill_id
    remove_column :rewards, :employee_id
  end

  def down
  	add_column :rewards, :skill_id, :integer
  	add_column :rewards, :employee_id, :integer
  end
end