class RequestSkill < ActiveRecord::Base
  attr_accessible :request_id, :skill_id

  belongs_to :request

end
