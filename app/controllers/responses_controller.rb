class ResponsesController < ApplicationController
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def index
    @request = Request.find(params[:request_id])
    @responses = @request.responses.page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @responses }
    end
  end

  def show
    @request = Request.find(params[:request_id])
    @response = @request.response.find(params[:id])

      respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @response }
    end
  end

  def new
    @request = Request.find(params[:request_id])
    @session = Employee.find(current_employee[:id])
    @response = @request.responses.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @response }
    end
  end

  def create
   @request = Request.find(params[:request_id])
   @session = Employee.find(current_employee[:id])
   @response = @request.responses.build(params[:response])

    if params[:cancel_button]
      redirect_to requests_path
    elsif @response.save  
      respond_to do |format|
          format.html { redirect_to requests_path, notice: 'Thank you for volunteering!'}
      end
    elsif !@response.save
      respond_to do |format|
        format.html { render :action => 'new'}
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @request = Request.find(params[:request_id])
    @response = @request.responses.find(params[:id])
  end

  def update
    @request = Request.find(params[:request_id])
    @session = Employee.find(current_employee[:id])  
    @response = @request.responses.find(params[:id])
    if @response.update_attributes(params[:response])
      
      redirect_to request_response_url(@response.request_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @request = Request.find(params[:request_id])
    @response = @request.responses.find(params[:id])
    @response.destroy

    flash[:notice] = "Successfully destroyed comment."
    redirect_to request_responses_url(@response.request_id)
  end


end