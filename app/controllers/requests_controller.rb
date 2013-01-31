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
    #Only cancelled requests have a status attribute given by requestor. The other requests pull from model method.
    @open_requests = Request.where(status.nil?).order(:id).page(params[:page]).per(5)

    @commissions = Commission.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @requests }
    end
  end

  def show
    @request = Request.find_by_employee_id(current_employee)
    @skills = Skill.all
    relevant_skills = params[:relevant_skills]

    if !params[:relevant_skills].nil?
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

    if !params[:relevant_skills].nil?
      relevant_skills = @request.relevant_skills.split(", ")
    end

  end

  def create
    @request = current_employee.requests.build(params[:request])
    @skills = Skill.all 

     @request.relevant_skills = params[:relevant_skills].to_a
     @request.relevant_skills = @request.relevant_skills.join(", ")


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

    @request.relevant_skills = params[:relevant_skills].to_a
    @request.relevant_skills = @request.relevant_skills.join(", ")

    if params[:cancel_button]
      redirect_to _employee_requests_path
    elsif @request.update_attributes(params[:request])
      flash[:success] = "Request cancelled."
      redirect_to _employee_requests_path
    elsif @request.update_attributes(params[:request])
      flash[:success] = "Request updated"
      redirect_to _employee_requests_path
    else
      render 'edit'
    end

  end 

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    respond_with(@request)
  end

end
