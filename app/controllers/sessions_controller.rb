class SessionsController < ApplicationController
  
  def new
  end

  def create
    employee = Employee.find_by_email(params[:email])
    if employee && employee.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = employee.auth_token
      else
        cookies[:auth_token] = employee.auth_token
      end
        redirect_to requests_url
    else
      redirect_to root_url, :notice => "Invalid email or password"      
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "Logged out!"
  end

#  def self.sweep(time = 1.hour)
#    if time.is_a?(String)
#      time = time.split.inject { |count, unit| count.to_i.send(unit) }
#    end
 
#    delete_all "updated_at < '#{time.ago.to_s(:db)}' OR
#      created_at < '#{2.days.ago.to_s(:db)}'"
#  end

end
