class DesiredSkillsController < ApplicationController
  # GET /desired_skills
  # GET /desired_skills.json
  def index
    @employee = Employee.find_by_id(params[:employee_id])
    # @desired_skills = @employee.desired_skills.all
    @desired_skills = DesiredSkill.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @desired_skills }
    end
  end

  # GET /desired_skills/1
  # GET /desired_skills/1.json
  def show
    @employee = Employee.find_by_id(params[:employee_id])
    @desired_skill = @employee.desired_skill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @desired_skill }
    end
  end

  # GET /desired_skills/new
  # GET /desired_skills/new.json
  def new
    @employee = Employee.find_by_id(params[:employee_id])
    # @desired_skill = @employee.desired_skill.new
    @desired_skill = DesiredSkill.new 

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @desired_skill }
    end
  end

  # GET /desired_skills/1/edit
  def edit
    @employee = Employee.find_by_id(params[:employee_id])
    @desired_skill = @employee.desired_skill.find(params[:id])
  end

  # POST /desired_skills
  # POST /desired_skills.json
  def create
    @employee = Employee.find_by_id(params[:employee_id])
    # @desired_skill = @employee.desired_skill.new(params[:desired_skill])
    @desired_skill = DesiredSkill.new(params[:desired_skill]) 

    respond_to do |format|
      if @desired_skill.save
        format.html { redirect_to employee_desired_skill_url, notice: 'Desired skill was successfully created.' }
        format.json { render json: @desired_skill, status: :created, location: @desired_skill }
      else
        format.html { render action: "new" }
        format.json { render json: @desired_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /desired_skills/1
  # PUT /desired_skills/1.json
  def update
    @employee = Employee.find_by_id(params[:employee_id])
    @desired_skill = @employee.desired_skill.find(params[:id])

    respond_to do |format|
      if @desired_skill.update_attributes(params[:desired_skill])
        format.html { redirect_to employee_desired_skill_url, notice: 'Desired skill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @desired_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /desired_skills/1
  # DELETE /desired_skills/1.json
  def destroy
    @employee = Employee.find_by_id(params[:employee_id])
    @desired_skill = @employee.desired_skill.find(params[:id])
    @desired_skill.destroy

    respond_to do |format|
      format.html { redirect_to employee_desired_skills_url }
      format.json { head :no_content }
    end
  end
end
