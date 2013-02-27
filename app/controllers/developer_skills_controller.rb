class DeveloperSkillsController < ApplicationController
  # GET /developer_skills
  # GET /developer_skills.json
  def index
    @employee = Employee.find_by_id(params[:employee_id])
    @developer_skills = @employee.developer_skills.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @developer_skills }
    end
  end

  # GET /developer_skills/1
  # GET /developer_skills/1.json
  def show
    @employee = Employee.find_by_id(params[:employee_id])
    @developer_skill = @employee.developer_skill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @developer_skill }
    end
  end

  # GET /developer_skills/new
  # GET /developer_skills/new.json
  def new
    @employee = Employee.find_by_id(params[:employee_id])
    @developer_skill = @employee.developer_skill.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @developer_skill }
    end
  end

  # GET /developer_skills/1/edit
  def edit
    @employee = Employee.find_by_id(params[:employee_id])
    @developer_skill = @employee.developer_skill.find(params[:id])
  end

  # POST /developer_skills
  # POST /developer_skills.json
  def create
    @employee = Employee.find_by_id(params[:employee_id])
    @developer_skill = @employee.developer_skill.new(params[:developer_skill])

    respond_to do |format|
      if @developer_skill.save
        format.html { redirect_to employee_developer_skill_url, notice: 'Developer skill was successfully created.' }
        format.json { render json: @developer_skill, status: :created, location: @developer_skill }
      else
        format.html { render action: "new" }
        format.json { render json: @developer_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /developer_skills/1
  # PUT /developer_skills/1.json
  def update
    @employee = Employee.find_by_id(params[:employee_id])
    @developer_skill = @employee.developer_skill.find(params[:id])

    respond_to do |format|
      if @developer_skill.update_attributes(params[:developer_skill])
        format.html { redirect_to employee_developer_skill_url, notice: 'Developer skill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @developer_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /developer_skills/1
  # DELETE /developer_skills/1.json
  def destroy
    @employee = Employee.find_by_id(params[:employee_id])
    @developer_skill = @employee.developer_skill.find(params[:id])
    @developer_skill.destroy

    respond_to do |format|
      format.html { redirect_to employee_developer_skills_url }
      format.json { head :no_content }
    end
  end
end
