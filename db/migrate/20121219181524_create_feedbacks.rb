class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :comment
      t.string :name

      t.timestamps
    end
  end
end
