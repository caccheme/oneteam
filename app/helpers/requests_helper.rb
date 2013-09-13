module RequestsHelper

#location name(id): Chicago(1), Mumbai(2), Houston(3), San Francisco(4), Boston(5), London(6) 
def get_request_location(id) #request location position for comparison
  latlng2 = []
    if id == 1
      latlng2 = [41.8781136, -87.62979819999998]
    elsif  id == 2
      latlng2 = [19.0759837, 72.87765590000004]
    elsif id == 3
      latlng2 = [29.7601927, -95.36938959999998]
    elsif id == 4
      latlng2 = [37.7749295, -122.41941550000001] 
    elsif id == 5
      latlng2 = [42.3584308, -71.0597732]
    elsif id == 6
      latlng2 = [ 51.51121389999999, -0.11982439999997041] 
    end                  
  return latlng2
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