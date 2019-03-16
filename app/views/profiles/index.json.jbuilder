json.array!(@profiles) do |profile|
  json.extract! profile, :id, :last_name, :first_name, :middle_initial, :nick_name, :date_of_birth, :gender, :address, :city, :country, :state, :zip,  :contact_method
  json.url profile_url(profile, format: :json)
end
