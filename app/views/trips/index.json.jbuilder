json.array!(@trips) do |trip|
  json.extract! trip, :id, :employee_id, :lovedone_id, :status, :state, :latitude, :longitude
  json.url trip_url(trip, format: :json)
end
