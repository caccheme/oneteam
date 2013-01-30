class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.integer :years_with_company
      t.string :manager
      t.string :position
      t.string :department
      t.string :group
      t.string :location
      t.string :current_skills
      t.string :skills_interested_in
      t.string :auth_token
      t.datetime :password_reset_sent_at
      t.string :password_reset_token 
      t.string :password_digest
      t.string :image
      

      t.timestamps
    end
  end
end
