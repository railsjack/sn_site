class CreateAdminService
  def call
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.profile = Profile.create
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        #user.confirm!
        #https://stackoverflow.com/questions/38693705/nomethoderror-undefined-method-confirm-for-user
        user.confirm
        user.admin!
      end
  end
end


