class DropOfficesTable < ActiveRecord::Migration
  def up
    drop_table :offices
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end