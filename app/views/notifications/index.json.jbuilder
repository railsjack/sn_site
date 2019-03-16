json.array!(@notifications) do |notification|
  json.extract! notification, :id, :employee_id, :lovedone_id, :status, :notification_type
  json.url notification_url(notification, format: :json)
end
