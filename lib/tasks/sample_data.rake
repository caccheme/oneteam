namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Department.create!(name: "IT")

    groups = ["Development","Interface Design","QA", "Infrastructure"]
    groups.each do |group_name|
      Group.create!(name: group_name)
    end

    locations = ["Chicago", "Mumbai", "Houston","San Francisco", "Boston", "London"]
    locations.each do |location_name|
      Location.create!(name: location_name)
    end
     
    positions = ["Engineer", "Analyst","Project Lead", "UI Specialist", "QA Specialist"] 
    positions.each do |position_name|
      Position.create!(name: position_name)
    end

    skills = ["PHP", "MySQL", "C#", "Apache", "Ruby on Rails", "SQL Server", "Linux"]
    skills.each do |skill_name|
      Skill.create!(name: skill_name)
    end

    locations_and_developers_hash = {1=>45, 2=>5, 3=>32, 4=>14, 5=>20, 6=>12}   # {location=>requests}
    all_requests = [] 
    one_request_each = []    
    locations_and_developers_hash.each do |location_id, number_developers|
      number_developers.times do |n|
      Employee.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "employee-#{n+1}@aits.com", 
        manager: Faker::Name.name, description: Faker::Lorem.paragraph(sentence_count = 2), years_with_company: rand(10-1) + 1, 
        position_id: rand(5-1) + 1, department_id: rand(1-1) + 1, group_id: rand(5-1) + 1, location_id: location_id, password: "foobar", 
        password_confirmation: "foobar")      
        if location_id != 3 && all_requests.size < 120 #no Houston requests and 120 requests total                 
          if location_id == 2 && one_request_each.size < 1  #three requests: three developers with one request each
            Request.create!(description: Faker::Lorem.paragraph(sentence_count = 2), title: Faker::Name.title, employee_id: n,
            start_date: Date.today-(10*rand()), end_date: Date.today+(100*rand()), group_id:   

              )

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


            #code to create one request for one developer from this location
          elsif location_id == 4 && one_request_each.size < 2
            #same code
          elsif location_id == 5 && one_request_each.size < 3
            #same code

              #logic to create more than 10 requests each for two specific developers
              #those two developers cannot be the developers used in the last loop

              #logic to create enough requests for 120 total, from 20 developers total,
              #with at least a few from each office, these developers cannot be from
              #the first loop
          end  
        end
      end   
          
       
    end
  end
end  