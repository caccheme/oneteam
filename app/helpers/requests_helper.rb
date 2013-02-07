module RequestsHelper

def current_skills_not_nil?(employee)
    if !current_skills.nil?
      current_skills.split(", ")
    end
end    

def relevant_skills_not_nil?(request)
  if !relevant_skills.nil?
    relevant_skills.split(", ")
  end
end


end
