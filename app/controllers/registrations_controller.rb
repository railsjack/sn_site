class RegistrationsController < Devise::RegistrationsController
	def new
		@featured_companies = Company.featured
		@transports = Company.transports
		@home_healths = Company.home_healths
		@sponsors_ads = Sponsor.ads

		super
	end
	def create
		@sponsors_ads = Sponsor.ads

		@post_method = true
		
		if params[:query] == "serviceprovider"
			super
			unless resource.id == nil
				company = resource.build_company(sign_up_params_for_company[:company_attributes])
				resource.company = company
				resource.admin = true
				# company.user_id = resource.id
				company.time_zone = 'Eastern Time (US & Canada)'
				resource.role = "serviceprovider"
				if company.save and resource.save
					SystemMailer.delay.receiveapp_email(resource.email)
					SystemMailer.delay.admin_request_email(resource)
				end

			end

			unless resource.id == nil
				set_flash_message :notice, :signed_up_but_unconfirmed_for_serviceprovider if is_flashing_format?
			end
		end

		if params[:query] == "family"
			super
			unless resource.id == nil
				resource.send_on_create_confirmation_instructions_ex
				resource.profile.user_type = Profile.user_types[:family_member]
				if resource.save
					invitations = Invitation.where(email: resource.email)
					invitations.destroy_all unless invitations.nil?
				end

				lovedone_id = sign_up_params_for_lovedone_id[:lovedones_attributes][:id]
				unless lovedone_id == nil
					follower = Follower.new
					follower.user_id = resource.id
					follower.lovedone_id = lovedone_id
					follower.request_status = "invited"
					if follower.save
						set_flash_message :notice, :signed_up_but_unconfirmed_for_family if is_flashing_format?
					end
				end
			end
		end

		if params[:query] == "user"
			lovedone_params = sign_up_params_for_lovedone[:lovedones_attributes]
      r = lovedone_params[:date_of_birth].split('/')
      lovedone_params[:date_of_birth] = "#{r[1]}/#{r[0]}/#{r[2]}"
      @lovedone = Lovedone.new lovedone_params
      
			#render :text=>(@lovedone.nil?).inspect and return
			super
			unless resource.id==nil
				resource.send_on_create_confirmation_instructions_ex
				set_flash_message :notice, :signed_up_but_unconfirmed_for_user if is_flashing_format?
			end
			unless resource.id == nil
				@lovedone.save
				primary_contact = PrimaryContact.new
				primary_contact.user_id = resource.id
				primary_contact.lovedone_id = @lovedone.id
				primary_contact.save
				@lovedone.primary_contact_id = primary_contact.id
				@lovedone.save
				profile_id = resource.profile.id
				sign_up_params_for_leads[:leads].each do |lead|
					if !lead[:company_name].blank? or !lead[:phone_number].blank?
						phone_number = ''
						phone_number = lead[:phone_number] if lead[:phone_number].index('_')==nil
						ld = Lead.new name: lead[:company_name], phone_number: phone_number, profile_id: profile_id
						ld.save
					end
				end
				follower = Follower.new
				follower.user_id = resource.id
				follower.lovedone_id = @lovedone.id
				follower.request_status = "approved"
				follower.save
				if sign_up_params_for_invite[:invites]
					primary_contact_name = "#{params[:user][:profile_attributes][:first_name]} #{params[:user][:profile_attributes][:last_name]}"
					lovedone_name = "#{params[:user][:lovedones_attributes][:first_name]} #{params[:user][:lovedones_attributes][:last_name]}"
					sign_up_params_for_invite[:invites].each do |invite|
						puts 'invite'
						puts invite.inspect
						unless invite[:email].empty?
							invitation = Invitation.new email: invite[:email], lovedone_id: @lovedone.id
							invitation.save
							SystemMailer.invite_email(invite[:email], primary_contact_name,lovedone_name, invitation.id).deliver
						end
					end
				end

				unless params[:selected_providers].blank?
					r = params[:selected_providers].split(",")
					r.each do |company_id|
						provider = Provider.new company_id: company_id, lovedone_id: @lovedone.id
						provider.save
					end
				end
			end
		end
	end

	def edit
		resource.emails.build if resource.emails.blank?
		super
	end

	def update
		super
		resource.update_attributes(update_params_for_user)
	end

	def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms,
    	profile_attributes: [:first_name, :last_name, :phone_number, {:contact_method => []}, :city, :county, :state],
    	)
	end

	def update_params_for_user
		params.require(:user).permit(emails_attributes: [:id, :email, :_destroy])
	end

	def sign_up_params_for_company
    devise_parameter_sanitizer.sanitize(:sign_up)
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms,
    	company_attributes: [:company_name, :business_name, :address, :city, :county, :state, :county, :zip, :telephone, 
    		:mobile_phone_number, :contact_last_name, :contact_first_name, :provider_type, :get_notification, {:contact_method => []}, :notification_masking, :lovedone_masking]
    	)
  end

  def sign_up_params_for_primary_contact
    devise_parameter_sanitizer.sanitize(:sign_up)
    #lovedones_attributes
    params.require(:user).permit(:name, :email, :password,
    	profile_attributes: [:first_name, :last_name, :phone_number, :city, :state, :county, :email, :password, :password_confirmation, :terms, {:contact_method => []}]
    	)
  end

  def sign_up_params_for_leads
    devise_parameter_sanitizer.sanitize(:sign_up)
    #lovedones_attributes
    params.require(:user).permit(
    	leads: [:company_name, :phone_number]
    	)
  end


  def sign_up_params_for_lovedone
    devise_parameter_sanitizer.sanitize(:sign_up)
    #lovedones_attributes
    params.require(:user).permit(
    	lovedones_attributes: [:last_name, :first_name, :middle_initial, :nick_name, :date_of_birth, :gender, :apt_unit, :street, :city, :county, :state, :zip_code]
    	)
  end

  def sign_up_params_for_lovedone_id
    devise_parameter_sanitizer.sanitize(:sign_up)
    #lovedones_attributes
    params.require(:user).permit(
    	lovedones_attributes: [:id]
    	)
  end

  def sign_up_params_for_invite
    devise_parameter_sanitizer.sanitize(:sign_up)
    #lovedones_attributes
    params.require(:user).permit(
    	invites: [:email]
    	)
  end


	protected
	  def after_sign_up_path_for(resource)
	    url_for(controller: 'static_pages', action: 'thankyou')+"?nohead=true"
	  end  
	  def after_inactive_sign_up_path_for(resource)
	    url_for(controller: 'static_pages', action: 'thankyou')+"?nohead=true"
	  end  

end

