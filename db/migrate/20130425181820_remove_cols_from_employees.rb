class RemoveColsFromEmployees < ActiveRecord::Migration
  def up
  	remove_column :employees, :location
  	remove_column :employees, :position
  	remove_column :employees, :group
  	remove_column :employees, :department
  end

  def down
 	add_column :employees, :location, :string
  	remove_column :employees, :position, :string
  	remove_column :employees, :group, :string
  	remove_column :employees, :department, :string
   end
end