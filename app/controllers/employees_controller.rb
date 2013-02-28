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
    @skills = Skill.all
    @employee = Employee.find(params[:id])
 
    # developer_skills = params[:developer_skills]

    # if !params[:developer_skills].nil?
    #   developer_skills = @employee.developer_skills.split(", ")
    # end

    # desired_skills = params[:desired_skills]

    # if !params[:desired_skills].nil?
    #   desired_skills = @employee.desired_skills.split(", ")
    # end

  end

  def create
    @employee = Employee.new(params[:employee])

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
  
    if params[:cancel_button]
      redirect_to @employee
    elsif @employee.update_attributes(params[:employee])
      respond_to do |format|
        format.html { redirect_to @employee, notice: 'Employee profile was successfully updated.' }
        format.json { head :no_content }
      end  
    # elsif !@employee.update_attributes(params[:employee])
    #   respond_to do |format|
    #     format.html { render action: "edit" }
    #     format.json { render json: @employee.errors, status: :unprocessable_entity }
    #   end
    end
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    
    respond_with(@employee)
  end

end