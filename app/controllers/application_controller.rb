class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_employee
  helper_method :author?
  helper_method :owner?
  helper_method :assigner?
  helper_method :check_for_cancel, :current_date

private
 
  def current_date
    DateTime.now
  end

  def check_for_cancel
    session[:return_to] ||= request.referer
     if params[:commit] == 'Cancel'
       redirect_to session[:return_to]
     end
  end

  def current_employee
    @current_employee ||= Employee.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def signed_in_employee
    unless signed_in?
      redirect_to log_in_url, notice: "Please sign in."
    end
  end

  def signed_in?
    !current_employee.nil?
  end

  def author? (request)
    request[:employee_id] == current_employee.id
  end

  def owner? (employee)
    employee[:id] == current_employee.id
  end

end