json.array!(@employees) do |employee|
  json.extract! employee, :id, :latitude, :longitude, :company_id, :lovedone_id, :name, :username, :password
  json.url employee_url(employee, format: :json)
end
