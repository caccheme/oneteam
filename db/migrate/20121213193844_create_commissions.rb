class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.integer :response_id
      t.integer :employee_id
      t.string :comment
      t.integer :request_id
      t.string :name

      t.timestamps
    end
  end
end
