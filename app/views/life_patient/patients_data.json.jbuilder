
json.array!(@patients) do |patient|
  # json.(patient, :id, :first_name, :middle_initial, :last_name, :date_of_birth, :phone_number, :street, :apt_unit, :city, :county, :state, :zip_code)
  if patient.imported_at.present? and patient.updated_at > patient.imported_at
    status = 'Changed'
  else
    status = 'New'
  end
  json.import_status status
  json.safety_notice_id patient.id
  json.first_name patient.first_name
  json.middle_initial patient.middle_initial
  json.last_name patient.last_name
  json.date_of_birth patient.date_of_birth
  json.gender patient.gender == 'true' ? 'M' : 'F'
  json.phone_number patient.phone_number
  json.address patient.street
  json.unit_no patient.apt_unit
  json.city patient.city
  json.county patient.county
  json.state patient.state
  json.zip patient.zip_code
  json.followers_attributes patient.followers do |follower|
    json.safety_notice_id follower.try(:id)
    json.first_name follower.try(:first_name)
    json.last_name follower.try(:last_name)
    json.email follower.try(:email)
    json.classification 'primary'
  end
end