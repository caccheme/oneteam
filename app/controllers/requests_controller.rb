class RequestsController < ApplicationController
 respond_to :html, :json
 before_filter :signed_in_employee
 before_filter :check_for_cancel, :only => [:create, :update]

  def employee_requests
    @all_requests = Request.find_all_by_employee_id(current_employee)
    @employee_requests = Request.order(:id).page(params[:page]).per(5) 
    @rewards = Reward.all 
    @evaluations = Evaluation.all 

  end

  def index
    @requests = Request.all
    @open_requests = Request.where('status IS NOT "Cancelled"').order(:id).page(params[:page]).per(4)
    @commissions = Commission.all

    @employees = Employee.all
    @responses = Response.find(:all, :conditions => :request_id == :id)

    @developer_skills = DeveloperSkill.find_all_by_employee_id(current_employee.id)
    @desired_skills = DesiredSkill.find_all_by_employee_id(current_employee.id)

    respond_to do |format|
      format.html 
      format.json { render json: @requests }
    end
  end

  def show
    @request = Request.find_by_employee_id(current_employee)
    
    # @skills = Skill.all
    # relevant_skills = params[:relevant_skills]

    # unless params[:relevant_skills].nil?
    #   relevant_skills = @request.relevant_skills.split(", ")
    # end
    
  end

  def new
    @request = Request.new
    @skills = Skill.all  
    
    respond_with(@request)
  end

  def edit 
    @request = Request.find(params[:id])
    @skills = Skill.all

    relevant_skill = params[:relevant_skill]

    unless params[:relevant_skill].nil?
      relevant_skill = @request.relevant_skill.split(", ")
    end

  end

  def create
    @request = current_employee.requests.build(params[:request])

    @request.relevant_skill = params[:relevant_skill].to_a 
    @request.relevant_skill = @request.relevant_skill.join(", ") 
    @skills = Skill.all  

    if params[:cancel_button]
      redirect_to _employee_requests_path
    elsif @request.save     
      respond_to do |format|
          format.html { redirect_to requests_path, notice: 'Request was successfully created.' }
          format.json { render json: @request, status: :created, location: @request }
      end
    elsif !@request.save
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @request = Request.find(params[:id])
    
    @request.relevant_skill = params[:relevant_skill].to_a
    @request.relevant_skill = @request.relevant_skill.join(", ")
    
    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to _employee_requests_path }
        format.json { head :no_content }
      elsif params[:cancel_button]
        format.html { redirect_to _employee_requests_path }
      end
    end
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    respond_with(@request)
  end

end
