OneteamApp::Application.routes.draw do

  resources :desired_skills
  resources :developer_skills
  resources :request_skills

  get "calendars/index"
  get "password_resets/new"

  resources :feedbacks
  resources :commissions

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

  resources :employees do
    resources :desired_skills
    resources :developer_skills
  end

  resources :request do
    resources :request_skills
  end
  
  resources :employees
  resources :sessions
  resources :requests
  resources :responses
  resources :password_resets

end