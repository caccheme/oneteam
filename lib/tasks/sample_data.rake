namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do

    def create_res(req_id, emp_id)
      num_days = [1.days, 2.days, 4.days, 8.days]
      created_at = Request.find(req_id).created_at + num_days.sample
      new_res = Response.create!(:request_id => req_id,
                                 :comment => Faker::Lorem.words(num = 4),
                                 :employee_id => emp_id,
                                 :created_at => created_at)
      new_res
    end

    def create_comm(req_id)
      num_days = [0.days, 1.days, 3.days, 5.days]
      created_at = Response.find_by_request_id(req_id).created_at + num_days.sample
      res_id = Response.find_by_request_id(req_id).id
      new_comm = Commission.create!(:response_id => res_id,
                                    :comment => Faker::Lorem.words(num = 4),
                                    :created_at => created_at)
      new_comm
    end

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


    locs_num_devs_hash = {1=>45, 2=>5, 3=>32, 4=>14, 5=>20, 6=>12}   # {location=># of devs}    
    employee_counter = 0 

    locs_num_devs_hash.each do |loc_id, num_devs|
      num_devs.times do |n|       
        Employee.create!(first_name: Faker::Name.first_name, 
                         last_name: Faker::Name.last_name, 
                         email: "employee-#{n+1}@aits.com", 
                         manager: Faker::Name.name, 
                         description: Faker::Lorem.paragraph(sentence_count = 2), 
                         years_with_company: rand(10-1) + 1, 
                         position_id: rand(5-1) + 1, 
                         department_id: rand(1-1) + 1, 
                         group_id: rand(5-1) + 1, 
                         location_id: loc_id, 
                         password: "foobar", 
                         password_confirmation: "foobar")
        DeveloperSkill.create!(:employee_id => n,
                               :skill_id => rand(1..7),
                               :level => rand(0..4))
        DesiredSkill.create!(:employee_id => n,
                             :skill_id => rand(1..7),
                             :level => rand(0..4))
        employee_counter += 1
      end
    end

    #no reqs from loc 3 (id's 51..82)
    # loc_emp_ids = {1=>[1..45], 2=>[46..50], 3=>[51..82], 4=>[83..96], 5=>[97..116], 6=>[117..128]}

    employees = Employee.all
    emp_ids = employees.map{|emp| emp.id }      

    loc_num_req_hash = {1=> { :requests => [1, 1, 1, 11, 11] },
                        2=> { :requests =>  [7, 7, 7, 7, 7, 7] },
                        4=> { :requests => [7, 7, 7] },
                        5=> { :requests => [8, 8]},
                        6=> { :requests => [4, 4, 4, 4] } 
                      }
    request_counter = 0

    loc_num_req_hash.each do |loc_id, req_hash|
      if loc_id == 1
        req_emp_ids = (1..45).to_a 
      elsif loc_id == 2
        req_emp_ids = (46..50).to_a 
      elsif loc_id == 4
        req_emp_ids = (83..96).to_a
      elsif loc_id == 5
        req_emp_ids = (97..116).to_a
      elsif loc_id == 6
        req_emp_ids = (117..128).to_a 
      end
 
      array = req_hash[:requests]
      array.each do |num_reqs|
        num_reqs.times do |m|
          x = rand(skills.length)
          relevant_skill = skills.slice(x, skills.length - x)
          start_date = rand(6.months).ago
          new_req = Request.create!(employee_id: emp_ids.sample,
                                    description: Faker::Lorem.sentence(word_count = 5),
                                    title: Faker::Lorem.sentence(word_count = 1),
                                    start_date: start_date,
                                    end_date: start_date + 6.months,
                                    relevant_skill: relevant_skill.join(", "),
                                    location_id: loc_id,
                                    group_id: rand(5-1) + 1,
                                    created_at: (rand*15).days.ago )
          request_counter += 1
        end
      end    
    end

    reqs = Request.all 
    req_ids, req_loc_ids, req_emp_ids = reqs.map{|req| req.id }, reqs.map{|req| req.location_id }, reqs.map{|req| req.employee_id }
    req_info = req_ids.zip req_emp_ids, req_loc_ids #array with 120 elements (1 for each request) [[req_id, req_emp_id, req_loc_id]...]

    three_resp_ids, two_resp_ids, nine_resp_ids, all_resp_ids, rest_resp_ids = [], [], [], [], []
    one_comm_ids, seven_comm_ids, rand_comm_ids = [], [], []

    req_info.each do |req_id, req_emp_id, req_loc_id| #this will go through each of the 120 requests
      #each London req has 3 responses
      if req_loc_id == 6 && three_resp_ids.size < 48
        3.times do
          res = create_res(req_id, emp_ids.sample)
          three_resp_ids << res.id
          all_resp_ids << res.id
          # 42 selections random
          if rand_comm_ids.size < 42
            comm = create_comm(req_id)
            rand_comm_ids << comm.id
          end
        end
      end
      #two responses personal (response.employee_id == request.employee_id)
      if two_resp_ids.size < 2 && req_loc_id == 4
        resp_emp_id = req_emp_id
        res = create_res(req_id, resp_emp_id)
        two_resp_ids << res.id
        all_resp_ids << res.id
          #1 personal responses selected
          if one_comm_ids.size < 1
            comm = create_comm(req_id)
            one_comm_ids << comm.id
          end
      end
      #nine responses local (response.location == request.location)
      e = emp_ids.sample
      if Employee.find_by_id(e).location_id == req_loc_id && e != req_emp_id && nine_resp_ids.size < 9
        res = create_res(req_id, e)
        nine_resp_ids << res.id
        all_resp_ids << res.id
        #7 local responses selected
        if seven_comm_ids.size < 7
          comm = create_comm(req_id)
          seven_comm_ids << comm.id
        end
      end
      # need leftover responses to get to 70
      if rest_resp_ids.size < 11
        res = create_res(req_id, emp_ids.sample)
        rest_resp_ids << res.id
      end
    end 

  end
end