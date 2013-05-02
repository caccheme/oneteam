namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
   
    def create_req(loc_id, emp_id)
      start_date = rand(6.months).ago    
      new_req = Request.create!(employee_id: emp_id,
                                description: Faker::Lorem.sentence(word_count = 5),
                                title: Faker::Lorem.sentence(word_count = 1),
                                start_date: start_date,
                                end_date: start_date + 6.months,
                                location_id: loc_id,
                                group_id: rand(5-1) + 1)
      new_req
    end
    
    def create_res(req_id, emp_id)
      num_days = [1.days, 2.days, 4.days, 8.days]
      created_at = Request.find(req_id).created_at + num_days.sample
      new_res = Response.create!(:request_id => req_id,
                                 :comment => Faker::Lorem.words(num = 4),
                                 :employee_id => emp_id,
                                 :created_at => created_at 
                                 )
      new_res
    end

    def create_comm(req_id)
      num_days = [0.days, 1.days, 3.days, 5.days]
      created_at = Response.find_by_request_id(req_id).created_at + num_days.sample
      res_id = Response.find_by_request_id(req_id).id
      new_comm = Commission.create!(:response_id => res_id,
                                    :comment => Faker::Lorem.words(num = 4),
                                    :created_at => created_at 
                                    )
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

    locs_and_devs_hash = {1=>45, 2=>5, 3=>32, 4=>14, 5=>20, 6=>12}   # {location=># of devs}    
    one_each_ids = []
    mt_ten_each_ids = []    
    all_reqs_ids = []

    locs_and_devs_hash.each do |loc_id, num_devs|
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
        #no requests for Houston (location_id:3), I'm going to filter by emp_id so will choose employee id's from 1 to 45
        #create three requests: three developers with one request each
        emp_id = Employee.last.id
        if emp_id == 1 && one_each_ids.size < 1 || emp_id == 2 && one_each_ids.size < 2 || emp_id == 3 && one_each_ids.size < 3  
          req = create_req(loc_id, emp_id)
          one_each_ids << req.id
          all_reqs_ids << req.id 
        end
        #create > 10 requests for two diff employees
        if emp_id == 4 && mt_ten_each_ids.size < 12 || emp_id == 5 && mt_ten_each_ids.size < 25
          11.times do
            req = create_req(loc_id, emp_id)
            mt_ten_each_ids << req.id
            all_reqs_ids << req.id
          end
        end
        #create rest of reqs up to 120 (already have 25), 20 devs total (already have 5), and no devs from one_each or mt_ten_each (employees 1 - 5) 
        #loc_ids & emp ids {1=>[1..45], 2=>[46..50], 3=>[51..82], 4=>[83..96], 5=>[97..116], 6=>[117..128]}
        #loc, emp, and num_reqs made => [[loc_id, emp_id, num_reqs]] so that 15 devs used and 120 reqs created
        rest_req_info = []
        rest_req_info = [[2, 46, 7], [2, 48, 7], [4, 83, 7], [4, 85, 7], [4, 90,7], [4,95, 7], [5, 98, 7], [5, 95, 7], [5, 100, 7], [5, 110, 8], 
                        [5, 115, 8], [6, 118, 4], [6, 120, 4], [6, 123, 4], [6, 127, 4]]
        if all_reqs_ids.size < 120
          rest_req_info.each do |loc_id, employee_id, num_reqs|
            if employee_id == emp_id
              num_reqs.times do 
                req = create_req(loc_id, emp_id)
                all_reqs_ids << req.id
              end             
            end
          end  
        end     
      end
    end

    #create total of 70 responses for reqs and 50 commissions
    emps = Employee.all
    emp_ids = emps.map{|emp| emp.id }
    #no responses from Mumbai
    resp_emp_ids = []
    (46..50).each do |id|
      resp_emp_ids = emp_ids.delete_if { |x| x == id }
    end

    reqs = Request.all
    req_ids = reqs.map{|req| req.id }
    req_loc_ids = reqs.map{|req| req.location_id }  
    req_emp_ids = reqs.map{|req| req.employee_id }
    req_info = req_ids.zip req_emp_ids, req_loc_ids #array with 120 elements (1 for each request) [[req_id, req_emp_id, req_loc_id]...] 

    three_resp_ids = []
    two_resp_ids = []
    nine_resp_ids = []
    all_resp_ids = []

    one_comm_ids = []
    seven_comm_ids = []
    rand_comm_ids = []

    req_info.each do |req_id, req_emp_id, req_loc_id| #this will go through each of the 120 requests 
      #each London req has 3 responses
      if req_loc_id == 6 && three_resp_ids.size < 48
        3.times do
          res = create_res(req_id, resp_emp_ids.sample)
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
      e = resp_emp_ids.sample
      if Employee.find_by_id(e).location_id == req_loc_id  && e != req_emp_id && nine_resp_ids.size < 9 
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
      if req_loc_id == 1 && all_resp_ids.size < 70
        res = create_res(req_id, resp_emp_ids.sample) 
        all_resp_ids << res.id
      end
    end         
    
  end
end