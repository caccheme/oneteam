class AddColsToRequests < ActiveRecord::Migration
  def up
    add_column :requests, :location_id, :integer
    add_column :requests, :group_id, :integer
    remove_column :requests, :location
    remove_column :requests, :group
  end

  def down
    remove_column :requests, :location_id 
    remove_column :requests, :group_id 
    add_column :requests, :location, :string
    add_column :requests, :group, :string
  end

end