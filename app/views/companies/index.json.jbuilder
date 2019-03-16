json.array!(@companies) do |company|
  json.extract! company, :id, :company_name, :business_name, :provider_type, :telephone, :mobile_phone_number, :get_notification, :user_id, :address, :city, :country, :state, :zip, :contact_last_name, :contact_first_name
  json.url company_url(company, format: :json)
end
