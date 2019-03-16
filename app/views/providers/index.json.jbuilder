json.array!(@providers) do |provider|
  json.extract! provider, :id, :company_id, :lovedone_id
  json.url provider_url(provider, format: :json)
end
