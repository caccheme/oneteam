class PasswordResetsController < ApplicationController
  def new
  end

  def create
    employee = Employee.find_by_email(params[:email])
    employee.send_password_reset if employee
    if params[:cancel_button]
      redirect_to root_url 
    elsif params[:submit_button]
      employee.send_password_reset
      redirect_to root_url, :notice => "Email sent with password reset instructions." 
    end
  end

  def edit
    @employee = Employee.find_by_password_reset_token!(params[:id])
  end

  def update
    @employee = Employee.find_by_password_reset_token!(params[:id])
    if @employee.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @employee.update_attributes(params[:employee])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
