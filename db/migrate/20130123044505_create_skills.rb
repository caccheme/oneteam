class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :language

      t.timestamps
    end
  end
end
