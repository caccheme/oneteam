# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130123044505) do

  create_table "commissions", :force => true do |t|
    t.integer  "response_id"
    t.integer  "employee_id"
    t.string   "comment"
    t.integer  "request_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "description"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.integer  "years_with_company"
    t.string   "manager"
    t.string   "position"
    t.string   "department"
    t.string   "group"
    t.string   "location"
    t.string   "current_skills"
    t.string   "skills_interested_in"
    t.string   "auth_token"
    t.datetime "password_reset_sent_at"
    t.string   "password_reset_token"
    t.string   "password_digest"
    t.string   "image"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "comment"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "requests", :force => true do |t|
    t.string   "description"
    t.string   "status"
    t.string   "relevant_skills"
    t.string   "title"
    t.string   "group"
    t.string   "location"
    t.integer  "employee_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "responses", :force => true do |t|
    t.integer  "request_id"
    t.integer  "employee_id"
    t.string   "comment"
    t.string   "employee_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "skills", :force => true do |t|
    t.string   "language"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
