class DataSyncingService
  def self.data_syncing(params)
    # p action['guid']
    # p action['timestamp']
    # p action['trip_id']
    # p action['trip_status']
    # p action['employe_id']
    # p action['loved_one_id']
    # p action['lat']
    # p action['lng']
    syncing_state = false
    # employee = Employee.find(params[:id])
    # if employee.present?
    if params[:data].present?
      result = JSON.parse(params[:data])
      actions = result['actions']
      shift_logs = result['shifts_log']
      if actions.present?
        actions.each do |action|
          if action['trip_id'] != -1 and (action['guid'] == -1 or action['guid'] == '')
            trip = Trip.find(action['trip_id'])
            if trip.present?
              if trip.status.downcase != action['trip_status']
                # When trip is created on web and mobile go to offline mode
                if action['trip_status'] == 'started'
                  params = {employee_id: action['employe_id'], lovedone_id: action['loved_one_id'], id: action['trip_id']}
                  trip_params = {start_latitude: action['lat'], start_longitude: action['lng'], status: action['trip_status']}
                  result_trip = TripService.update(params, trip_params)
                  result_trip.update(trip_params)
                  result_trip.timesheet.starttime = DateTime.strptime(action['timestamp'].to_s,'%Q')
                  result_trip.timesheet.save
                elsif action['trip_status'] == 'completed'
                  params = {employee_id: action['employe_id'], lovedone_id: action['loved_one_id'], id: action['trip_id']}
                  trip_params = {end_latitude: action['lat'], end_longitude: action['lng'], status: action['trip_status']}
                  result_trip = TripService.update(params, trip_params)
                  result_trip.update(trip_params)
                  result_trip.timesheet.endtime = DateTime.strptime(action['timestamp'].to_s,'%Q')
                  result_trip.timesheet.save
                elsif action['trip_status'].downcase == 'removed'
                  trip.delete
                end
              end
            end
          elsif action['guid'] != -1 and (action['trip_id'] == -1 or action['trip_id'] == '')
            # If trip is created in offline mode and exists with remote id
            trip = Trip.where(remote_id: action['guid']).first
            if trip.present?
              if action['trip_status'].downcase == 'started'
                params = {employee_id: action['employe_id'], lovedone_id: action['loved_one_id'], id: trip.id}
                trip_params = {start_latitude: action['lat'], start_longitude: action['lng'], status: action['trip_status']}
                result_trip = TripService.update(params, trip_params)
                result_trip.update(trip_params)
                result_trip.timesheet.starttime = DateTime.strptime(action['timestamp'].to_s,'%Q')
                result_trip.timesheet.save
              elsif action['trip_status'].downcase == 'completed'
                params = {employee_id: action['employe_id'], lovedone_id: action['loved_one_id'], id: trip.id}
                trip_params = {end_latitude: action['lat'], end_longitude: action['lng'], status: action['trip_status']}
                result_trip = TripService.update(params, trip_params)
                result_trip.update(trip_params)
                result_trip.timesheet.endtime = DateTime.strptime(action['timestamp'].to_s,'%Q')
                result_trip.timesheet.save
              elsif action['trip_status'].downcase == 'removed'
                trip.delete
              end
            else
              # If trip does not exists with remote id then create new trip
              if action['trip_status'].downcase == 'active'
                trip_params = {employee_id: action['employe_id'], lovedone_id: action['loved_one_id'], start_latitude: action['lat'], start_longitude: action['lng'], status: action['trip_status'], remote_id: action['guid']}
                params = {operation_mode: nil}
                trip = TripService.create(params, trip_params)
                trip.save
              end
            end
          end
        end
        syncing_state = true
      end

      if shift_logs.present?
        # Syncing for the shifts that are encountered in offline mode of mobile
        shift_logs.each do |shift|
          employee = shift['employee_id']
          activity = Activity.where(employee_id: employee, shift_started: true, shift_completed: false).first
          if shift['shift_status'] == 0
            if activity.present?
              activity.shift_completed = true
              activity.end_time = DateTime.strptime(shift['timestamp'].to_s,'%Q')
              activity.save
            end
          elsif shift['shift_status'] == 1
            if activity.nil?
              new_activity = Activity.new
              new_activity.employee_id = employee
              new_activity.company_id = Employee.find(employee).try(:company).try(:id)
              new_activity.shift_started = true
              new_activity.start_time = DateTime.strptime(shift['timestamp'].to_s,'%Q')
              new_activity.save
            end
          end
        end
        syncing_state = true
      end
    else
      syncing_state = false
    end
    syncing_state
  end
end
