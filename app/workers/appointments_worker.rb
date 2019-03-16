class AppointmentsWorker
  include Sidekiq::Worker

  sidekiq_options :failures => true

  def perform(id, count=nil)
    schedule_appointment(id, count)
  end

  def schedule_appointment(id, count=nil)
    schedule = Scheduler.find(id)
    employee = schedule.employee
    lovedone = schedule.lovedone
    Time.zone = employee.company.time_zone.present? ? employee.company.time_zone : 'UTC'
    timesheet = Timesheet.where("DATE_FORMAT(starttime, '%Y-%m-%d')=? and employee_id=? and lovedone_id=? and status=0 and starttime >=? ", Date.current.strftime('%Y-%m-%d'), employee.id, lovedone.id, Time.zone.now - 15.minutes)

    if timesheet.count > 0 and timesheet.first.starttime < (schedule.start_time + (employee.company.late_notice_notification.time_threshold).minutes)
      p '********************NOT LATE******************'
      timesheet.first.update_column(:status, 1)

    elsif schedule.late_notice.nil?
      p '************************LATE NOTICE GENERATED********************'
      if employee.company.late_notice_notification.present? and employee.company.late_notice_notification.system_status
        unless employee.company.late_notice_notification.contact_method.index('email').nil?
          SystemMailer.delay.late_notice_email(employee.company.late_notice_notification.email, employee, lovedone, schedule.start_time.strftime('%H:%M'))
        end
        require 'open-uri'
        account_sid = Rails.application.secrets.twilio_sid
        auth_token = Rails.application.secrets.twilio_token
        @client = Twilio::REST::Client.new account_sid, auth_token

        unless employee.company.late_notice_notification.contact_method.index('text').nil?
          to_number = employee.company.late_notice_notification.phone_number
          if employee.company.notification_masking
            first_last_name = "#{lovedone.first_name} #{lovedone.last_name[0]}"
          else
            first_last_name = "#{lovedone.first_name} #{lovedone.last_name}"
          end
          body = "Late Notice - Employee: #{employee.first_name} #{employee.last_name}; Loved One: #{first_last_name}; Appointment Time: #{schedule.start_time.strftime('%H:%M')}"
          to_number = to_number.gsub(/\D/, "")
          if to_number.size == 10
            to_number = '+1' + to_number

            @client.messages.create(
                :from => Rails.application.secrets.twilio_from_number,
                :to => to_number,
                :body => body
            )
          end
        end
      end
      # AppointmentsWorker.perform_in(15.minutes, schedule.id, 0)
      schedule.update_column(:late_notice, Time.zone.now)

    # else
    #   p '***********************WAITING FOR LATE ARRIVAL*************************'
    #   if count.present? and count < 4
    #     AppointmentsWorker.perform_in(15.minutes, schedule.id, count + 1)
    #   end
    end
    puts "Appointment with #{employee.full_name} is executed successfully"
  end
end
