class CommissionsController < ApplicationController
  before_filter :signed_in_employee
  
  def index
    @commissions = Commission.order(:request_id).page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @commissions }
    end
  end

  def show
    @response = Response.find(params[:response_id])
    @commission = @response.commission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @commission }
    end
  end

  def new
    @response = Response.find(params[:response_id])
    @commission = @response.commissions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @commission }
    end
  end

  def edit
    @response = Response.find(params[:response_id])
    @commission = @response.commissions.find(params[:id])
  end

  def create
    @response = Response.find(params[:response_id])   
    @commission = @response.commissions.build(params[:commission])

    if params[:cancel_button]
      redirect_to _my_requests_path
    elsif @commission.save
      respond_to do |format|
        format.html { redirect_to _my_requests_path, :notice => 'Successfully assigned developer.' }
      end
    elsif !@commission.save
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @response = Response.find(params[:response_id])
    @commission = @response.commissions.find(params[:id])

    respond_to do |format|
      if @commission.update_attributes(params[:commission])
        format.html { redirect_to requests_path, notice: 'Commission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @commission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy    
    @commission = Commission.find(params[:id])
    @commission.destroy

    respond_to do |format|
      format.html { redirect_to commissions_url }
      format.json { head :no_content }
    end
  end
end
