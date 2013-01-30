module SessionsHelper

  def signed_in_employee
    unless signed_in?
      store_location
      redirect_to login_url, notice: "Please sign in."
    end
  end

end
