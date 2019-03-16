json.array!(@primary_contacts) do |primary_contact|
  json.extract! primary_contact, :id
  json.url primary_contact_url(primary_contact, format: :json)
end
