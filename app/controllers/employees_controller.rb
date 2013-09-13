class EmployeesController < ApplicationController
  include EmployeesHelper  
  respond_to :html, :json
  before_filter :signed_in_employee, only: [:edit, :update, :index]
  before_filter :current_employee
  before_filter :check_for_cancel, :only => [:create, :update]

  def employee_requests
      @requests = Request.find_all_by_employee_id(current_employee)
      @responses = Response.find_all_by_request_id(@requests)
      @commissions = Commission.find_all_by_request_id(@requests)
      @current_date = DateTime.now
  end

  def index
    @employees = Employee.all 

    respond_with(@employees)
  end

  def show
    @employee = Employee.find(params[:id])
    @requests = Request.all
    @commissions = Commission.where('employee_id' => params[:id])
    @my_commissions = Commission.order(:id).page(params[:page]).per(5)
    @skills = Skill.all
    # @employee_commissions = @employee.commissions
    
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
    @locations = Location.all
    @departments = Department.all
    @groups = Group.all
    @positions = Position.all
    @skills = Skill.all
  end

  def create
    @employee = Employee.new(params[:employee])
    @skills = Skill.all

    if params[:cancel_button]
      redirect_to root_url
    elsif @employee.save
      @employee.to_developer_skills(@employee.current_skills) 
      @employee.to_desired_skills(@employee.skills_interested_in)
      flash[:notice] = "Successfully created account profile."
      redirect_to root_url, :notice => "Your account was created. Sign in!"
    elsif !@employee.save
      render "new"
    end
  end

  def update
    @employee = Employee.find(params[:id])
    @skills = Skill.all

    if params[:cancel_button]
      redirect_to @employee
    elsif @employee.update_attributes(params[:employee])
      @employee.to_developer_skills(@employee.current_skills)
      @employee.to_desired_skills(@employee.skills_interested_in)
      redirect_to @employee  
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