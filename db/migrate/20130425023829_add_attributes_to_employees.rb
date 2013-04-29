class AddAttributesToEmployees < ActiveRecord::Migration
  def up
    add_column :employees, :location_id, :integer
    add_column :employees, :group_id, :integer
    add_column :employees, :department_id, :integer
    add_column :employees, :position_id, :integer
  end

  def down
    remove_column :employees, :location_id 
    remove_column :employees, :group_id
    remove_column :employees, :department_id
    remove_column :employees, :position_id
  end

end
