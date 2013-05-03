class RewardsController < ApplicationController
  
  def index
    @commission = Commission.find(params[:commission_id])
    @rewards = Reward.all
    @skills = Skill.all
    @developer_skills = DeveloperSkill.all
    @request_skills = RequestSkill.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rewards }
    end
  end

  def show
    @skills = Skill.all
    @commission = Commission.find(params[:commission_id])
    @reward = Reward.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reward }
    end
  end

  def new
    @commission = Commission.find(params[:commission_id])
    @reward = @commission.build_reward(params[:reward])
    @skills = Skill.all
    @developer_skills = DeveloperSkill.all
    @request_skills = RequestSkill.all
    evaluation = @reward.evaluations.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reward }
    end
  end

  def edit
    @commission = Commission.find(params[:commission_id])
    @reward = Reward.find(params[:id])
    @skills = Skill.all

  end

  def create
    @commission = Commission.find(params[:commission_id])
    @reward = @commission.build_reward(params[:reward])
    @developer_skills = DeveloperSkill.find_by_employee_id(:employee_id)
    @request_skills = RequestSkill.find_by_request_id(:request_id)
    @skills = Skill.all

    respond_to do |format|
      if @reward.save
       
        format.html { redirect_to commission_reward_path(@commission, @reward) }
        format.json { render json: @reward, status: :created, location: @reward }
      else
        format.html { render action: "new" }
        format.json { render json: @reward.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @commission = Commission.find(params[:commission_id])
    @reward = Reward.find(params[:id])
    @skills = Skill.all

    respond_to do |format|
      if @reward.update_attributes(params[:reward])
        format.html { redirect_to @reward, notice: 'Reward was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reward.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy

    respond_to do |format|
      format.html { redirect_to rewards_url }
      format.json { head :no_content }
    end
  end

end