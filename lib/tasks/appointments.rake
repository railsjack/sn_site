namespace :appointments do
  task appointments_check: :environment do

    appointments = Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')=? and status=0",  Date.current.strftime('%Y-%m-%d'))
    if appointments.count > 0
      appointments.each do |appointment|
        employee = appointment.employee
        lovedone = appointment.lovedone
        timesheet = Timesheet.where("DATE_FORMAT(start_time, '%Y-%m-%d')=? and employee_id=? and lovedone_id=?", Date.current.strftime('%Y-%m-%d'), employee.id, lovedone.id).first

        if timesheet.count > 0
          TripService.late_notice(employee, lovedone, appointment, timesheet)
        elsif appointment.starttime > DateTime.now
        end
      end
    end

  end
end
