json.array!(@lovedones) do |lovedone|
  json.extract! lovedone, :id, :last_name, :first_name, :middle_initial, :nick_name, :date_of_birth, :gender, :city, :country, :state
  json.url lovedone_url(lovedone, format: :json)
end
