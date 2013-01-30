class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :description
      t.string :status
      t.string :relevant_skills
      t.string :title
      t.string :group
      t.string :location
      t.integer :employee_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
