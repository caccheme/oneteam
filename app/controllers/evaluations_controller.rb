class EvaluationsController < ApplicationController
 
  def index
    @reward = Reward.find(params[:reward_id])
    @evaluations = Evaluation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @evaluations }
    end
  end

  def show
    @reward = Reward.find(params[:reward_id]) 
    @evaluation = Evaluation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @evaluation }
    end
  end

  def new
    @reward = Reward.find(params[:reward_id]) 
    @evaluation = @reward.evaluations.build 
    # @evaluation = Evaluation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @evaluation }
    end
  end

  def edit
    @reward = Reward.find(params[:reward_id]) 
    @evaluation = Evaluation.find(params[:id])
  end

  def create
    @reward = Reward.find(params[:reward_id]) 
    @evaluation = @reward.evaluations.build(params[:evaluation])
    # @evaluation = Evaluation.new(params[:evaluation])

    respond_to do |format|
      if @evaluation.save
        format.html { redirect_to @evaluation, notice: 'Evaluation was successfully created.' }
        format.json { render json: @evaluation, status: :created, location: @evaluation }
      else
        format.html { render action: "new" }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @reward = Reward.find(params[:reward_id]) 
    @evaluation = Evaluation.find(params[:id])

    respond_to do |format|
      if @evaluation.update_attributes(params[:evaluation])
        format.html { redirect_to @evaluation, notice: 'Evaluation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @evaluation = Evaluation.find(params[:id])
    @evaluation.destroy

    respond_to do |format|
      format.html { redirect_to evaluations_url }
      format.json { head :no_content }
    end
  end
end
