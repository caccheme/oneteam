class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :eval_number
      t.integer :level
      t.integer :reward_id
      t.integer :skill_id
      t.integer :employee_id

      t.timestamps
    end
  end
end
