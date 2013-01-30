OneteamApp::Application.routes.draw do

  resources :requests do
    get :cancel_request
  end

  get "cancel_request" => "requests#cancel_request", :as => "cancel_request"
 
  resources :skills

  get "calendars/index"

  get "password_resets/new"

  resources :feedbacks
  resources :commissions

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "employees#new", :as => "sign_up"
  get "my_requests" => "requests#my_requests", :as => "_my_requests"
  get "requests_calendar" => "requests#requests_calendar", :as => "_requests_calendar"
  get "my_requests_calendar" => "requests#my_requests_calendar", :as => "_my_requests_calendar"
  root :to => "sessions#new" 
  
  resources :requests do 
    resources :responses 
  end

  resources :responses do
      resources :commissions
  end 

  resources :employees
  resources :sessions
  resources :requests
  resources :responses
  resources :password_resets

end