class Evaluation < ActiveRecord::Base
  attr_accessible :employee_id, :eval_number, :level, :reward_id, :skill_id
  belongs_to :rewards 

  def average_eval
    average(self.eval_number).to_i 
  end 

end