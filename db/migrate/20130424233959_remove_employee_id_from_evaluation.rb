class RemoveEmployeeIdFromEvaluation < ActiveRecord::Migration
  def up
  	remove_column :evaluations, :employee_id
  end

  def down
  	add_column :evaluations, :employee_id, :integer
  end
end