# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# attempt at seeding without using migration, no idea what I'm doing:
# require 'open-uri'
# require 'active_record/fixtures'

# [1..6].each do |skill|
#   DesiredSkill.find_or_create_by_id(skill.skill_id)
#   DeveloperSkill.find_or_create_by_id(skill.skill_id)
#   RequestSkill.find_or_create_by_id(skill.skill_id)  
# end

# [1..6].each do |skill|
#   DesiredSkill.find_or_create_by_id(skill.skill_id)
#   DeveloperSkill.find_or_create_by_id(skill.skill_id)
# end

# Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "desired_skills", "developer_skills", "request_skills")