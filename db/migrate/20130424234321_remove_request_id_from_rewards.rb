class RemoveRequestIdFromRewards < ActiveRecord::Migration
  def up
  	remove_column :rewards, :request_id
  end

  def down
  	add_column :rewards, :request_id, :integer
  end
end