module RequestsHelper

#location name(id): Chicago(1), Mumbai(2), Houston(3), San Francisco(4), Boston(5), London(6) 
#hash that maps location IDs to [lat, long]. 
def get_request_location(office_id)
  office_locations = {1 => [41.8781136, -87.62979819999998], 
    2 => [19.0759837, 72.87765590000004],
    3 => [29.7601927, -95.36938959999998],
    4 => [37.7749295, -122.41941550000001],
    5 => [42.3584308, -71.0597732],
    6 => [ 51.51121389999999, -0.11982439999997041] 
  }
  office_locations[office_id]
end

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

def current_skill_score(rel_skill)
  @developer_skills.each do |dev_skill|
  language = Skill.find_by_id(dev_skill.skill_id).language
    if language == rel_skill
      @emp_skills.push(language)
      @emp_skills.push(dev_skill.level)
      @skill_score.push(dev_skill.level)
      break
    end
  end
@skill_score
@emp_skills
end

def interested_skill_score(rel_skill)
  @desired_skills.each do |dev_skill|
  language = Skill.find_by_id(dev_skill.skill_id).language
    if language == rel_skill
      @emp_skills.push(language)
      @emp_skills.push(dev_skill.level)
      @skill_score.push(dev_skill.level)
      break
    end
  end
@skill_score
@emp_skills
end

end