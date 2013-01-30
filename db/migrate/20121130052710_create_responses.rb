class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :request_id
      t.integer :employee_id
      t.string :comment
      t.string :employee_name

      t.timestamps
    end
  end
end
