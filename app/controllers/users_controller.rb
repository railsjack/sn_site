class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    
    #list of individual users
    @profiles = Profile.all  
    #list of service providers
    @companies = Company.all
      
    #user is from admins page  
    current_user.accounts!        
      
    authorize User  
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  #admin/dashboard    
  def dashboard
    authorize current_user
    if current_user.admin?
      @lovedone_count = Lovedone.all.count
      # @primary_contact_count = PrimaryContact.all.count
      @family_members_count = Follower.all.count
      @service_provider_count = Company.all.count
      @service_provider_count1 = Company.companies_with_transport
      @service_provider_count2 = Company.companies_with_home_health
      @notifications_count = Notification.all.count
      @companies_awaiting = Company.companies_awaiting
    
    elsif current_user.serviceprovider?
      @lovedone_count = current_user.company.providers.all.count
      # @primary_contact_count = current_user.company.providers.all.count
      @family_members_count = Follower.all.count
      @service_provider_count = Company.all.count
      @service_provider_count1 = Company.companies_with_transport
      @service_provider_count2 = Company.companies_with_home_health
      @notifications_count = Notification.all.count
      @companies_awaiting = Company.companies_awaiting
    
    elsif current_user.user?
      @lovedone_count = "Access denited"
      @primary_contact_count = "Access denited"
      @family_members_count = "Access denited"
      @service_provider_count = "Access denited"
      @service_provider_count1 = "Access denited"
      @service_provider_count2 = "Access denited"
      @notifications_count = "Access denited"
      @companies_awaiting = "Access denited"
    end



  end 
    
  def providers
    authorize current_user  
    @companies = Company.all
    #user is from admins page  
    current_user.providers!
  end

  def admins
    authorize current_user   
    @profiles = Profile.all
    #user is from admins page  
    current_user.admins!  
  end
    
  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def update_by_admin
    @user = User.find(params[:id])
    authorize current_user
    if @user.update_attributes(secure_params)
      puts "secure_params[:email]"
      puts secure_params[:email].inspect
      puts "@user"
      puts @user.inspect
      if @user.email != secure_params[:email]
        redirect_to :back, :notice => "You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address."
      else
        redirect_to :back, :notice => "User updated."
      end
    else
      redirect_to :back, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def which_account
      
  end
  def secure_params
    params.require(:user).permit(
      :email,
      profile_attributes: [:first_name, :middle_initial, :last_name, :gender, :phone_number, :city, :state, :county,:zip, :contact_method=>[] ])
  end

end

