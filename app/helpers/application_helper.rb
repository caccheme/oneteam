module ApplicationHelper

def avatar_url(employee)
  if employee.avatar_url.present?
    employee.avatar_url
  else
    default_url = "#{root_url}images/guest.png"
    gravatar_id = Digest::MD5.hexdigest(employee.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end
end

#def sortable(column, title = nil)
#  title ||= column.titleize
#  css_class = column == sort_column ? "current #{sort_direction}" : nil
#  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
#  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
#end
	
end
