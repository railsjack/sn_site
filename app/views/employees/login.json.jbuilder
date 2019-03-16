json.extract! @employee, :id, :latitude, :longitude, :company_id, :lovedone_id, :name, :username, :password, :created_at, :updated_at
json.extract! @employee.company, :id
