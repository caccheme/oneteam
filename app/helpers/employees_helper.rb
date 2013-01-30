module EmployeesHelper

def gravatar_for(employee)
    gravatar_id = Digest::MD5::hexdigest(employee.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: employee.first_name, class: "gravatar")
end

end
