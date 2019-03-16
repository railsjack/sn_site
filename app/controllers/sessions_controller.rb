class SessionsController < Devise::SessionsController
  # DELETE /resource/sign_out
  def destroy
    current_user.update_attributes(last_sign_out_at: Time.now)
    super
  end
end
