class CompanymembersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_company_member, only: [:show, :edit, :update, :destroy]

  # GET /company_members
  # GET /company_members.json
  def index
    @companies = Company.all
  end

  # GET /company_members/1
  # GET /company_members/1.json
  def show
  end

  # GET /company_members/new
  def new
    @company_member = User.new
  end

  # GET /company_members/1/edit
  def edit
    authorize! :read, Company

    @company_member = User.find(params[:id])
  end

  def zone_notification
    @company_member = User.find(params[:id])
    @company = @company_member.company
    if @company.zone_notification.nil?
      @company.build_zone_notification
    end
  end

  def update_notification
    @company_member = User.find(params[:id])
    company = @company_member.company
    respond_to do |format|
      if company.update_attributes(zone_notification_params)
        format.html { redirect_to zone_notification_companymember_path(@company_member), notice: 'Updated Successfully' }
      else
        format.html { redirect_to zone_notification_companymember_path(@company_member), notice: 'Not Updated' }
      end
    end
  end

  # POST /company_members
  # POST /company_members.json
  def create
    @company_member = User.new(company_member_params)
    @company_member.role = "serviceprovider"
    @company_member.admin = true
    respond_to do |format|
      if @company_member.save
        unless @company_member.company.nil?
          @company_member.company.status = "pending" unless @company_member.company.status.eql? 'approved'
          @company_member.company.build_zone_notification
          @company_member.company.save
          SystemMailer.delay.receiveapp_email(@company_member.email)
          SystemMailer.delay.admin_request_email(@company_member)
        end
        format.html { redirect_to companymembers_path, notice: 'Successfully created' }
      else
        format.html { render :new }
        format.json { render json: @company_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_members/1
  # PATCH/PUT /company_members/1.json
  def update
    @company_member = User.find(params[:id])
    params = company_member_params
    company = Company.find(@company_member.company.id)
    original_status = company.status
    company_params = params[:company_attributes]
    #@company_member.update(sign_up_params)

    email = sign_up_params[:email]
    success_message = "Successfully updated."
    unless email == @company_member.email
      unless @company_member.update(email: email)
        redirect_to :back, notice: "Could not change the email. #{@company_member.errors.messages[:email]}"
        return
      else
        if current_user.admin?
          success_message = "Successfully updated"
        else
          success_message = "To complete a change of email request, you must click on the confirmation link that our system sends to the new address."
        end
      end
    end

    password = sign_up_params[:password]
    unless password.blank?
      @company_member.password = password
      redirect_to :root and return if @company_member.save
    end

    respond_to do |format|
      
      if company.update(company_params)
        if original_status != company.status && company.status == "approved"
          @company_member.send_on_create_confirmation_instructions_ex
          #SystemMailer.receiveapp_email(@company_member.email).deliver
        end
        if current_user.admin?
          format.html { redirect_to companymembers_path, notice: success_message }
          format.json { render :show, status: :ok, location: @company_member }
        else
          format.html { redirect_to edit_companymember_path(@company_member), notice: success_message }
          format.json { render :show, status: :ok, location: @company_member }
        end
      end
    end

  end

  # DELETE /company_members/1
  # DELETE /company_members/1.json
  def destroy
    @company_member = User.find(params[:id])
    @company_member.destroy
    respond_to do |format|
      format.html { redirect_to companymembers_path, notice: 'Successfully deleted' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_company_member
    	@company_member = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_member_params
      params.require(:user).permit(:lastname, :firstname, :email, :mobilephone, :contact, :city, :county, :state, :username, :password,:password_confirmation,
        company_attributes: [:company_name, :business_name, :provider_type, 
          :telephone, :mobile_phone_number, :get_notification, :user_id, :address, :city, :time_zone,
          :county, :state, :zip, :picture, :featured, :contact_last_name, :contact_first_name, :distance_threshold, :time_threshold, :system_status, :early_arrival_status,:recurring_threshold,
          {:contact_method=>[]}, :status, :email, :latitude, :longitude, :notification_masking, :lovedone_masking, :id])
    end

    def zone_notification_params
      params.require(:company).permit(zone_notification_attributes: [:distance_threshold, :time_threshold, :recurring_threshold, :system_status, :early_arrival_status, :email, :phone_number, {contact_method: []}, :id])
    end

    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms, 
        profile_attributes: [:first_name, :last_name, :phone_number, {:contact_method => []}, 
        :city, :county, :state, :latitude, :longitude],
        )
    end

end
