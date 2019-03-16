class LifePatientController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:provider_data, :patients_data, :followers_data, :update_patients_status]
  # before_filter :authenticate_api_key, only: [:provider_data, :followers_data]

  def registration
    # 10.28.84.78:3000
    # lifepatient.com
    redirect_to 'http://lifepatient.com/users/sign_up?user_id='+current_user.id.to_s
  end

  def provider_data
    user = User.find(params[:user_id])
    company = user.company
    render json:{user: {
                   email: user.email,
                   provider:{
                      contact_first_name: company.contact_first_name,
                      contact_last_name: company.contact_last_name,
                      mobile_number: company.mobile_phone_number,
                      phone_number: company.telephone,
                      safety_notice_id: user.id,
                      business_name: company.business_name,
                      address: company.address,
                      city: company.city,
                      county: company.county,
                      state: company.state,
                      zip: company.zip
                   }
               }
           }
  end

  def patients_data
    company = User.find(params[:user_id]).company
    @patients = if params[:patient_ids].present?
                  company.lovedones.where(id: params[:patient_ids])
                else
                  company.lovedones
                end
    respond_to do |format|
      format.json
    end
  end

  def update_patients_status
    if params[:status] == 'update'
      if Lovedone.where(id: params[:patient_ids]).update_all(imported_at: Time.now)
        render json: {status: 'Updated'}
      else
        render json: {status: 'Not Updated'}
      end
    elsif params[:status] == 'delete'
      Lovedone.find(params[:patient_id]).update(imported_at: nil)
      render json: {status: 'Updated'}
    end
  end

  def followers_data
    lovedone = Lovedone.find(params[:patient_id])
    @followers = lovedone.followers
    # render json: followers
    respond_to do |format|
      format.json
    end
  end

  private
  def authenticate_api_key
    unless params[:key].eql? "29d4668010e566e6646e1e3cdb873268cf334bf3" or request.get?
      head :unauthorized
    end
  end
end
