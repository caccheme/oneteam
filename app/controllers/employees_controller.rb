class EmployeesController < ApplicationController
respond_to :html, :json
before_filter :signed_in_employee, only: [:edit, :update, :index]
before_filter :current_employee
before_filter :check_for_cancel, :only => [:create, :update]

  def index
    @employees = Employee.order(:id).page(params[:page]).per(10)

    respond_with(@employees)
  end

  def show
    @employee = Employee.find(params[:id])
    @requests = Request.all
    @commissions = Commission.all
    @my_commissions = Commission.order(:id).page(params[:page]).per(5)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee }
    end
  end

  def new
    @employee = Employee.new
    @skills = Skill.all

    respond_with(@employee)
  end

  def edit
    @employee = Employee.find(params[:id])
    @skills = Skill.all
    
    current_skills = params[:current_skills]

    if !params[:current_skills].nil?
      current_skills = @employee.current_skills.split(", ")
    end

    skills_interested_in = params[:skills_interested_in]

    if !params[:skills_interested_in].nil?
      skills_interested_in = @employee.skills_interested_in.split(", ")
    end

  end

  def create
    @employee = Employee.new(params[:employee])
    @skills = Skill.all
     
    if params[:cancel_button]
      redirect_to root_url
    elsif @employee.save
      flash[:notice] = "Successfully created account profile."
      redirect_to root_url, :notice => "Your account was created. Sign in!"
    elsif !@employee.save
      render "new"
    end
  end

  def update
    @employee = Employee.find(params[:id])
    @skills = Skill.all

    @employee.current_skills = params[:current_skills].to_a
    @employee.current_skills = @employee.current_skills.join(", ")

    @employee.skills_interested_in = params[:skills_interested_in].to_a
    @employee.skills_interested_in = @employee.skills_interested_in.join(", ")

    if params[:cancel_button]
      redirect_to @employee
    elsif @employee.update_attributes(params[:employee])
      respond_to do |format|
        format.html { redirect_to @employee, notice: 'Employee profile was successfully updated.' }
        format.json { head :no_content }
      end  
    elsif !@employee.update_attributes(params[:employee])
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    
    respond_with(@employee)
  end

end