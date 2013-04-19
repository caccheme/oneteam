class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.date :reward_date
      t.integer :request_id
      t.integer :skill_id
      t.integer :employee_id
      t.integer :commission_id

      t.timestamps
    end
  end
end
