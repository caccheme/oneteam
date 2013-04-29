class Evaluation < ActiveRecord::Base
  attr_accessible :eval_number, :level, :reward_id, :skill_id
  belongs_to :reward
  belongs_to :skill

  def average_eval
    average(self.eval_number).to_i 
  end 

end