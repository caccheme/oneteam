class RequestsController < ApplicationController
 respond_to :html, :json
 before_filter :signed_in_employee
 before_filter :check_for_cancel, :only => [:create, :update]

  def employee_requests
    @all_requests = Request.find_all_by_employee_id(current_employee)
    @employee_requests = Request.order(:id).page(params[:page]).per(5) 
  end

  def index
    @requests = Request.all
    @open_requests = Request.where('status IS NOT "Cancelled"').order(:id).page(params[:page]).per(4)
    @commissions = Commission.all

    respond_to do |format|
      format.html 
      format.json { render json: @requests }
    end
  end

  def show
    @request = Request.find_by_employee_id(current_employee)
    @skills = Skill.all
    relevant_skills = params[:relevant_skills]

    unless params[:relevant_skills].nil?
      relevant_skills = @request.relevant_skills.split(", ")
    end
    
  end

  def new
    @request = Request.new
    @skills = Skill.all  
    

    respond_with(@request)
  end

  def edit 
    @request = Request.find(params[:id])
    @skills = Skill.all

    relevant_skills = params[:relevant_skills]

    unless params[:relevant_skills].nil?
      relevant_skills = @request.relevant_skills.split(", ")
    end

  end

  def create
    @request = current_employee.requests.build(params[:request])
    @skills = Skill.all  

    @request.relevant_skills = params[:relevant_skills].to_a.join(", ")

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
    @skills = Skill.all
    @request.relevant_skills = params[:relevant_skills].to_a.join(", ")
    
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
