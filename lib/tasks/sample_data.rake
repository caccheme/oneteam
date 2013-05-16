namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    require 'faker'

    Employee.create!(first_name: "Chris",
                 last_name: 'R',
                 email: "chris@sample.com",
                 password: "abc123",
                 password_confirmation: "abc123",
                 location_id: 1)

    Employee.create!(first_name: "Charity",
                 last_name: "H",
                 email: "charity@sample.com",
                 password: "abc123",
                 password_confirmation: "abc123",
                 location_id: 2)

    employee_tables_hash = {Department=>["IT"],
                            Group=>["Development","Interface Design","QA", "Infrastructure"],
                            Location=>["Chicago", "Mumbai", "Houston","San Francisco", "Boston", "London"],
                            Position=>["Engineer", "Analyst","Project Lead", "UI Specialist", "QA Specialist"]}
    employee_tables_hash.each do |table, names|
      names.each do |name|
        table.create!(name: name)
      end
    end

    skills = ["PHP", "MySQL", "C#", "Apache", "Ruby on Rails", "SQL Server", "Linux"]
    skills.each do |name|
      Skill.create!(language: name)
    end

    #Current and Future Skills
    puts "Generating Sample Current and Future Skills"
    130.times do |n|
      7.times do |s|
        DeveloperSkill.create!(
          skill_id: s+1,
          employee_id: n+1,
          level: rand(0..4)
        )
        DesiredSkill.create!(
          skill_id: s+1,
          employee_id: n+1,
          level: rand(0..4)
        )
      end
    end
     
    #employee Breakdown: 45 in Chicago, 20 in Boston, 32 in Houston, 14 in San Francisco, 12 in London, 5 in Mumbai

    puts "Generating Sample employees" 

    locs_num_devs_hash = {1=>45, 2=>5, 3=>32, 4=>14, 5=>20} # {location=># of devs}
    locs_num_devs_hash.each do |loc_id, num_devs|
      num_devs.times do |n| 
      Employee.create!(id: n,
                       first_name: Faker::Name.first_name,
                       last_name: Faker::Name.last_name,
                       email: Faker::Internet.email,
                       password: "password",
                       password_confirmation: "password",
                       years_with_company: rand(1..20),
                       manager: Faker::Name.name,
                       position_id: rand(5-1) + 1,
                       department_id: rand(1-1) + 1,
                       group_id: rand(5-1) + 1,
                       location_id: loc_id)
      end
    end

  # Request Breakdown: 120 project request posts over 6 months from 20 of the developers, such that:
  # 3 developers posted once, 2 posted more than 10 requests, The rest were in between, No posts from London

  def get_random_start_date
    Array((Date.today - 3.months)..(Date.today + 3.months)).sample
  end

    puts 'Generating Sample Requests'
    
    #3 Employees posted once
    3.times do |n|
      Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                      description: Faker::Lorem.sentences(2).join(" "),
                      start_date: start_date = get_random_start_date,
                      end_date: start_date + rand(1..90).days,
                      group_id: rand(5-1) + 1,
                      employee_id: employee_id = n+4,
                      location_id: Employee.find_by_id(employee_id).location_id,
                      created_at: start_date 
                      )
    end

    #Employee over 10 requests
    17.times do
      Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                      description: Faker::Lorem.sentences(2).join(" "),
                      start_date: start_date = get_random_start_date,
                      end_date: start_date + rand(1..90).days,
                      group_id: rand(5-1) + 1,
                      employee_id: 7,
                      location_id: Employee.find_by_id(5).location_id,
                      created_at: start_date
                      ) 
    end

    #Employee #2 over 10 requests
    20.times do
      Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                      description: Faker::Lorem.sentences(2).join(" "),
                      start_date: start_date = get_random_start_date,
                      end_date: start_date + rand(1..90).days,
                      group_id: rand(5-1) + 1,
                      employee_id: 8,
                      location_id: Employee.find_by_id(6).location_id,
                      created_at: start_date
                      ) 
    end

    #Remaining Requests
    20.times do
    n = rand(9..Employee.all.length)
      4.times do
        Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                        description: Faker::Lorem.sentences(2).join(" "),
                        start_date: start_date = get_random_start_date,
                        end_date: start_date + rand(1..90).days,
                        group_id: rand(5-1) + 1,
                        employee_id: employee_id = n,
                        location_id: Employee.find_by_id(employee_id).location_id,
                        created_at: start_date 
                        )
      end
    end 

    #Relevant Skills
    puts 'Generating Sample Relevant Skills'
    120.times do |n|
      RequestSkill.create!(
        skill_id: rand(1..7),
        request_id: n)
    end

    #London employees created after to prevent them from posting requests
    12.times do
      Employee.create!(first_name: Faker::Name.name,
                   last_name: Faker::Name.name,
                   email: Faker::Internet.email,
                   password: "password",
                   password_confirmation: "password",
                   years_with_company: rand(1..20),
                   manager: "John",
                   position_id: rand(5-1) + 1,
                   department_id: rand(1-1) + 1,
                   group_id: rand(5-1) + 1,
                   location_id: 6) 
    end
    
    #Request Response Details:
    # 70 responses: 9 local, 2 personal, 0 to Mumbai Requests, All Londond requests received at least 3 responses
    # Some responses occurred a day after the request, some 2 days after, some 4, and some 8

    puts 'Generating Sample Responses'
#     #locations: 1=Chicago, 2=Mumbai, 3=Houston, 4 = San Francisco, 5=Boston, 6=London
    
    @response_locations = [1, 3, 4, 5 ]
   
    def get_random_response_datetime(request_date)
      [(request_date + 1.day), (request_date + 2.days), (request_date + 4.days), (request_date + 8.days)].sample
    end

    def find_response_employee_with_request(employee_location)
      employee_id = Employee.find_all_by_location_id(employee_location).map(&:id).sample
      request_id = Request.find_all_by_employee_id(employee_id).map(&:id).sample
      request_id == nil ? find_response_employee_with_request(employee_location) : employee_id
    end

    def find_unique_location(employee_location)
      unique_location = @response_locations.sample
      unique_location == employee_location ? find_unique_location(employee_location) : unique_location
    end

    #Local responses
    9.times do
      employee_location = @response_locations.sample
      employee_id = Employee.find_all_by_location_id(employee_location).map(&:id).sample
      request_id = Request.find_all_by_location_id(employee_location).map(&:id).sample
      
      Response.create!(
        comment: Faker::Lorem.sentences(2).join(" "),
        request_id: request_id,
        employee_id: employee_id,
        created_at: get_random_response_datetime(Request.find_by_id(request_id).start_date))
    end
    #Personal responses
    2.times do
      employee_location = @response_locations.sample
      employee_id = find_response_employee_with_request(employee_location)
      request_id = Request.find_all_by_employee_id(employee_id).map(&:id).sample

      Response.create!(
        comment: Faker::Lorem.sentences(2).join(" "),
        request_id: request_id,
        employee_id: employee_id,
        created_at: get_random_response_datetime(Request.find_by_id(request_id).start_date))
    end
    #Remaining responses w/ no Mumbai and not local 

    59.times do
      employee_location = @response_locations.sample
      other_location = find_unique_location(employee_location)
      employee_id = Employee.find_all_by_location_id(employee_location).map(&:id).sample
      request_id = Request.find_all_by_location_id(other_location).map(&:id).sample

      Response.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      request_id: request_id,
      employee_id: employee_id,
      created_at: get_random_response_datetime(Request.find_by_id(request_id).start_date))
    end

    # Request Assignment Details:
    # 50 request assignments: 7 of the 9 local responses selected, 1 of the 2 personal responses selected
    # Some responses are selected on the same day as a response, some a day later, some 3 days later, and some 5
    def get_random_commission_datetime(request_date)
      [ (request_date), (request_date + 1.day), (request_date + 3.days), (request_date + 5.days)].sample
    end

    puts 'Generating Sample Request Assignments'
    #local request assignments
    7.times do |n|
      response_id = n+2
      employee_id = Response.find_by_id(response_id).employee_id
      request_id = Response.find_by_id(response_id).request_id

      Commission.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      response_id: response_id,
      request_id: request_id,
      employee_id: employee_id,
      created_at: get_random_commission_datetime(Response.find_by_id(response_id).created_at))
    end

    #personal commission
      Commission.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      response_id: 10,
      request_id: Response.find_by_id(10).request_id,
      employee_id: Response.find_by_id(10).employee_id,
      created_at: get_random_commission_datetime(Response.find_by_id(10).created_at))

    #Remaining Request Assignments
    42.times do |n|
      response_id = n+11
      employee_id = Response.find_by_id(response_id).employee_id
      request_id = Response.find_by_id(response_id).request_id

      Commission.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      response_id: response_id,
      request_id: request_id,
      employee_id: employee_id,
      created_at: get_random_commission_datetime(Response.find_by_id(response_id).created_at))
    end

  end
end