json.array! @calendar_schedules do |schedule|
  json.id schedule.id
  json.employee_id schedule.try(:employee).try(:id)
  json.lovedone_id schedule.try(:lovedone).try(:id)
  json.title "#{schedule.try(:employee).try(:full_name)}: #{schedule.try(:lovedone).try(:full_name)}"
  json.start schedule.try(:start_time)
  json.end schedule.try(:end_time)
  if schedule.start_time.utc >= Time.zone.now
    json.color 'green'
  elsif schedule.start_time.utc < Time.zone.now
    json.color 'grey'
  end

end