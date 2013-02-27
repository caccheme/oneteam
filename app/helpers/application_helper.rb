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

	
  # # given a hash of attributes including the ID, look up the record by ID. 
  # # If it does not exist, it is created with the rest of the options. 
  # # If it exists, it is updated with the given options. 
  # #
  # # Raises an exception if the record is invalid to ensure seed data is loaded correctly.
  # # 
  # # Returns the record.
  # def self.create_or_update(options = {})
  #   id = options.delete(:id)
  #   record = find_by_id(id) || new
  #   record.id = id
  #   record.attributes = options
  #   record.save!
    
  #   record
  # end

#def sortable(column, title = nil)
#  title ||= column.titleize
#  css_class = column == sort_column ? "current #{sort_direction}" : nil
#  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
#  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
#end
	
end
