class EmployeeMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee_mailer.password_reset.subject
  #
  
  def password_reset(employee)
    @employee = employee
    mail :to => employee.email, :subject => "Password Reset"
  end

end
