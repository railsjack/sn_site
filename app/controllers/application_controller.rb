class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_browser_alert_session
  before_filter :set_time_zone

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def set_browser_alert_session
    if cookies[:browser_alert] != "false" or cookies[:browser_alert].nil?
      cookies[:browser_alert] = true
    end
  end

  def clear_browser_alert_session
    cookies[:browser_alert] = false
    render text: 'Cleared'
  end

  def set_time_zone
    I18n.locale = I18n.default_locale #request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    if current_user and (current_user.role == 'serviceprovider' or current_user.role == 'employee')
      time_zone = (current_user && current_user.company.time_zone ? current_user.company.time_zone : 'UTC')
      time_zone = "UTC" if time_zone.empty?
      Time.zone = time_zone
    end
  end

  protected
  def configure_permitted_parameters
    #devise_parameter_sanitizer.for(:sign_up) << :name
    #devise_parameter_sanitizer.for(:sign_up) << profile_attributes: [:first_name, :last_name] 
    #http://stackoverflow.com/questions/17868746/rails-4-unpermitted-parameters-for-array  
    #devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:id, :name, :role, :email, :username, :password, :password_confirmation, :terms, :last_name, :first_name, :nick_name, :date_of_birth, :gender, :city, :county, :state,
    #  profile_attributes: [:id, :user_id, :first_name, :last_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :county, :country, :state, :zip, {:contact_method => []}, :phone_number], 
    #  lovedones_attributes: [[:id, :first_name, :last_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :county, :country, :state]],
    #  company_attributes:[:id, :user_id,:company_name , :business_name , :provider_type , :telephone , :mobile_phone_number , :get_notification  , :user_id , :address , :city , :county , :country , :state , :zip , :contact_last_name , :contact_first_name, :status, {:contact_method => []}, :notification_masking, :lovedone_masking],
    #  )}

    #https://stackoverflow.com/questions/37341967/rails-5-undefined-method-for-for-devise-on-line-devise-parameter-sanitizer
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:id, :name, :role, :email, :username, :password, :password_confirmation, :terms, :last_name, :first_name, :nick_name, :date_of_birth, :gender, :city, :county, :state,
      profile_attributes: [:id, :user_id, :first_name, :last_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :county, :country, :state, :zip, {:contact_method => []}, :phone_number], 
      lovedones_attributes: [[:id, :first_name, :last_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :county, :country, :state]],
      company_attributes:[:id, :user_id,:company_name , :business_name , :provider_type , :telephone , :mobile_phone_number , :get_notification  , :user_id , :address , :city , :county , :country , :state , :zip , :contact_last_name , :contact_first_name, :status, {:contact_method => []}, :notification_masking, :lovedone_masking],
      )}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:id, :name, :role, :email, :password,:password_confirmation, :current_password, profile_attributes: [:id, :user_id, :first_name, :last_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :country, :state, :county, :zip, {:contact_method => []}, :phone_number], company_attributes:[:id, :user_id, :company_name , :business_name , :provider_type , :telephone , :mobile_phone_number , :get_notification  , :user_id , :address , :city , :country , :state, :county , :zip , :contact_last_name , :contact_first_name, :status, {:contact_method => []}, :notification_masking, :lovedone_masking])}


    #lovedones_attributes: {:lovedone=>[:id, :first_name, :last_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :county, :country, :state]}, 
    #devise_parameter_sanitizer.for(:account_update) << :name
    #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:id, :name, :role, :email, :password,:password_confirmation, :current_password, profile_attributes: [:id, :user_id, :first_name, :last_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :country, :state, :county, :zip, {:contact_method => []}, :phone_number], company_attributes:[:id, :user_id, :company_name , :business_name , :provider_type , :telephone , :mobile_phone_number , :get_notification  , :user_id , :address , :city , :country , :state, :county , :zip , :contact_last_name , :contact_first_name, :status, {:contact_method => []}, :notification_masking, :lovedone_masking])}
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Access denied."
    redirect_to (request.referrer || root_path)
  end

  def after_sign_out_path_for(resource_or_scope)
    return root_url if root_url.contains?('heroku')
    Rails.env.production? ? 'http://safetynotice.com/' : root_path
  end

end
