module EmployeesHelper

def gravatar_for(employee)
    gravatar_id = Digest::MD5::hexdigest(employee.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: employee.first_name, class: "gravatar")
end

def show_skill_and_level(skill_level)
    if skill_level.level != 0  
        language = Skill.find_by_id(skill_level.skill_id).language
        level = skill_level.level
        @skillname.push(language)
        @skillname.push(level)
    end
end

end
