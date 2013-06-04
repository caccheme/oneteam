OneteamApp::Application.routes.draw do

  resources :dashboards
  resources :positions
  resources :groups
  resources :departments
  resources :locations
  resources :offices
  resources :evaluations
  resources :skills
  resources :desired_skills
  resources :developer_skills
  resources :feedbacks
  resources :employees
  resources :sessions
  resources :password_resets

  get "impact_reports" => "dashboards#impact_reports"
  get "skills_reports" => "dashboards#skills_reports", :as => "_skills_reports"
  get "requests_reports" => "dashboards#requests_reports", :as => "requests_reports"
  get "calendars/index"
  get "password_resets/new"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "employees#new", :as => "sign_up"
  get "employee_requests" => "requests#employee_requests", :as => "_employee_requests"
  root :to => "sessions#new" 
  
  resources :requests do 
    resources :responses 
  end

  resources :responses do
      resources :commissions
  end 

  resources :commissions do
     resources :rewards
   end 
  
  resources :rewards do
    resources :evaluations
  end 

  resources :employees do
    resources :rewards
  end

end