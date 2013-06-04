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

ActiveRecord::Schema.define(:version => 20130520131232) do

  create_table "commissions", :force => true do |t|
    t.integer  "response_id"
    t.integer  "employee_id"
    t.string   "comment"
    t.integer  "request_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "dashboards", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "desired_skills", :force => true do |t|
    t.integer  "skill_id"
    t.integer  "employee_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "level",       :default => 3
  end

  create_table "developer_skills", :force => true do |t|
    t.integer  "skill_id"
    t.integer  "employee_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "level",       :default => 3
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
    t.string   "auth_token"
    t.datetime "password_reset_sent_at"
    t.string   "password_reset_token"
    t.string   "password_digest"
    t.string   "image"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "location_id"
    t.integer  "group_id"
    t.integer  "department_id"
    t.integer  "position_id"
  end

  create_table "evaluations", :force => true do |t|
    t.integer  "eval_number"
    t.integer  "level"
    t.integer  "reward_id"
    t.integer  "skill_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.string   "comment"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "request_skills", :force => true do |t|
    t.integer  "skill_id"
    t.integer  "request_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "requests", :force => true do |t|
    t.string   "description"
    t.string   "status"
    t.string   "title"
    t.integer  "employee_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "relevant_skill"
    t.integer  "location_id"
    t.integer  "group_id"
  end

  create_table "responses", :force => true do |t|
    t.integer  "request_id"
    t.integer  "employee_id"
    t.string   "comment"
    t.string   "employee_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "rewards", :force => true do |t|
    t.date     "reward_date"
    t.integer  "commission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "skills", :force => true do |t|
    t.string   "language"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
