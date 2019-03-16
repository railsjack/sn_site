require 'sidekiq/web'
Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  mount Sidekiq::Web, at: "/sidekiq"

  resources :timesheets
  resources :invoices
  resources :settings
  resources :companylovedones
  resources :familymembers
  resources :family_members
  resources :users
  resources :trips
  resources :messages

  resources :data_imports do
    collection do
      get :employees
      get :lovedones
      post :import_employees
      put :confirm_temp_employees
      get :cancel_temp_employees
      post :import_lovedones
      put :confirm_temp_lovedones
      get :cancel_temp_lovedones
      post :check_import_status
      get :spoke_changes
    end
  end

  resources :access_settings do
    collection do
      post :new_member
      post :edit_member
      post :update_member
      post :delete_member
      post :update_access
      post :member_history
      post :selected_history
    end
  end

  resources :schedulers do
    collection do
      get :scheduler_calendar
      get :existing_schedules
      get :new_schedule
      get :edit_schedule
      get :delete_schedule
      get :schedule_options
      get :another_employee_schedule
      get :late_notice_settings
      post :update_late_notice_settings
      get :transfer_appointments
    end
  end

  resources :tasks do
    resources :public_activity_activites, as: :activities
  end

  resources :companies do
    collection do
      get :restricted_lovedones
      get :lovedone_masking
    end
    resources :employees do
      collection do
        get :travel_history
      end
    end

    resources :companylovedones
    resources :designations
    resources :company_messages
    get 'employees_search', to: 'employees#search_by_params', as: 'employees_search'
  end

  resources :profiles do
    resources :leads
  end

  resources :lovedones do
    collection do
      get :lovedone_selection
    end
    resources :followers
    resources :providers
    resources :primary_contacts
    resources :lovedonecompanies

    get 'assign_primary_contact/:user_id', to: 'lovedones#assign_primary_contact', as: 'assign_primary_contact'
  end

  resources :companymembers do
    member do
      get :zone_notification
      post :update_notification
    end
  end

  resources :fees do
    collection do
      get :sponsor
      get :sp
      get :sp_fees_fields
      get :sponsor_fees_fields
    end
    member do
      post :update_sp_fees_fields
      post :update_sponsor_fees_fields
    end
  end

  resources :notifications do
    collection do
      get :calc
      post :calc_post
      post :monthly_sp_billing
      get '/calculations/:from/:to', to: 'notifications#calc_between', as: 'calc_notification_between'
      get '/calculations/:from/:to/:sponsor_id', to: 'notifications#calc_between', as: 'calc_notification_betweenx'
    end
  end

  resources :sponsors do
    collection do
      get :sponsor_type
    end
    member do
      post :update_sponsor_type
    end
  end

  resources :data_uploads do
    collection do
      get :data_upload_preview
      get :new_appointment
      get :settings
      post :update_upload_alert_time
      post :update_encounter_based
      post :add_appointment
    end
    member do
      post :update_settings
    end
  end

  get '/browser_alert', to: 'application#clear_browser_alert_session'
  get 'static_pages/thankyou', to: 'static_pages#thankyou'
  get 'tutorials/training_videos', to: 'static_pages#training_videos'
  get 'tutorials/user_guides', to: 'static_pages#user_guides'
  get 'tutorials/training_videos/:id', to: 'static_pages#training_videos', as: :tutorials_with_id
  get '/admin_employees', to: 'employees#admin_employees', as: 'admin_employees'
  get '/transfer_appointments/preview', to: 'schedulers#preview_appointments'
  get '/transfer_employees', to: 'schedulers#transfer_employees'
  get '/employee_send_appointments', to: 'schedulers#employee_send_appointments'
  get '/lovedone_send_appointments', to: 'schedulers#lovedone_send_appointments'

  get 'messages/index'
  get 'messages/new'
  get 'messages/edit'
  get 'messages/show'

  # get '/notifications/calculations', to: 'notifications#calc', as: 'calc_notification'
  # post '/notifications/calculations', to: 'notifications#calc_post', as: 'calc_notification_post'
  # get '/notifications/calculations/:from/:to', to: 'notifications#calc_between', as: 'calc_notification_between'
  # get '/notifications/calculations/:from/:to/:sponsor_id', to: 'notifications#calc_between', as: 'calc_notification_betweenx'

  patch 'upload', to: 'sponsors#upload'
  post 'upload', to: 'sponsors#upload'

  post '/api/employee/signin', to: 'mobile_user#login'

  # Life Patient Registration
  get '/life_patient/registration', to: 'life_patient#registration', as: :life_patient_registration
  post '/life_patient/provider_data', to: 'life_patient#provider_data'
  post '/life_patient/patients_data', to: 'life_patient#patients_data'
  post '/life_patient/followers_data', to: 'life_patient#followers_data'
  post '/life_patient/update_patients_status', to: 'life_patient#update_patients_status'

  post '/api/employee/activity', to: 'mobile_user#employee_activity'
  post '/api/employee/device_registration', to: 'mobile_user#device_registration'
  post '/api/employee/notification_response', to: 'mobile_user#notification_response'
  post '/api/employee/data_syncing', to: 'mobile_user#data_syncing'

  post '/api/employee/:employee/lovedone/:lovedone', to: 'mobile_user#pick_lovedone'
  post '/api/employee/:employee/dellovedone/:lovedone', to: 'mobile_user#drop_lovedone'
  post '/api/employee/:id/lovedones', to: 'mobile_user#getlovedones'
  post '/api/employee/:id/current_location', to: 'mobile_user#update_current_location'
  post '/api/employee/:id/trip/:trip_id/edit', to: 'mobile_user#updatelocation'
  post '/api/employee/:id/location', to: 'mobile_user#updateOnlyLocation'

  post '/api/trip/new', to: 'mobile_user#createtrip'
  post '/api/trip/update/:id', to: 'mobile_user#updatetrip'
  post '/api/trip/delete/:id', to: 'mobile_user#deletetrip'
  put  '/api/trip/:id', to: 'mobile_user#updatetrip'
  get '/api/trips/:employee_id', to: 'mobile_user#gettrips'

  get 'admin/dashboard', to: 'users#dashboard'
  get 'admin/providers', to: 'users#providers'
  get 'admin/users', to: 'users#admins'

  get 'admin/import_employees', to: 'employees#import_bulkdata', as: 'import_employees'
  post 'admin/import_employees', to: 'employees#import', as: 'import_employees_post'

  get 'admin/import_lovedones', to: 'lovedones#import_bulkdata', as: 'import_lovedones'
  post 'admin/import_lovedones', to: 'lovedones#import', as: 'import_lovedones_post'

  get 'admin/primary_contacts', to: 'primary_contacts#index'
  get 'admin/users/:id/edit', to: 'users#edit', as: 'user_edit'
  put 'admin/users/:id', to: 'users#update_by_admin', as: 'user_update'
  get 'admin/followers', to: 'followers#index'

  get '/companies/:company_id/track', to: 'employees#track'
  get '/companies/:company_id/track_locations', to: 'employees#track_locations', as: :track_locations
  get '/companies/:company_id/get_locations', to: 'employees#get_locations'
  get '/employees/get_locations', to: 'employees#get_locations'

  get '/companies/:company_id/rep_by_emp', to: 'employees#rep_by_emp', as: 'rep_by_emp'
  get '/companies/:company_id/rep_by_lovedone', to: 'employees#rep_by_lovedone', as: 'rep_by_lovedone'

  get '/employees/:id/track', to: 'employees#track_employee'
  get '/employee/:company_id/lovedones', to: 'employees#active_lo_update', as:'active_lo_update'

  get '/lovedones/:id/newprimary', to: 'lovedones#change_primary'

  get '/companies/:id/lovedones', to: 'companies#lovedones'
  get '/companies/:id/active_lovedones', to: 'companies#active_lovedones'

  get '/companies/:id/employee_lovedones', to: 'companies#employee_lovedones', as: 'employee_lovedones'
  post '/companies/:id/employee_lovedones', to: 'companies#employee_lovedones'
  delete 'employee_lovedone/:id', to: 'companies#employee_lovedone', as: 'employee_lovedone'

  get '/employees/travel_history_results', to: 'employees#travel_history_results'
  get '/employees/travel_history_map', to: 'employees#travel_history_map'

end


