json.array!(@family_members) do |family_member|
  json.extract! family_member, :id, :lastname, :firstname, :email, :mobilephone, :contact, :city, :county, :state, :username, :password
  json.url family_member_url(family_member, format: :json)
end
