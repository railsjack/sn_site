class TripService
  def self.calculate_distance( lat1, lon1, lat2, lon2 )
    rad_per_deg = 0.017453293   #  PI/180
    # the great circle distance d will be in whatever units R is in
    rmiles = 3956               # radius of the great circle in miles
    rkm = 6371                  # radius in kilometers...some algorithms use 6367
    rfeet = rmiles * 5282       # radius in feet
    rmeters = rkm * 1000        # radius in meters
    @distances = Hash.new       # this is global because if computing lots of track point distances, it didn't make
    # sense to new a Hash each time over potentially 100's of thousands of points
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    dlon_rad = dlon * rad_per_deg
    dlat_rad = dlat * rad_per_deg

    lat1_rad = lat1 * rad_per_deg
    lon1_rad = lon1 * rad_per_deg

    lat2_rad = lat2 * rad_per_deg
    lon2_rad = lon2 * rad_per_deg

    # puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.asin( Math.sqrt(a))

    dMi = rmiles * c          # delta between the two points in miles
    dKm = rkm * c             # delta in kilometers
    dFeet = rfeet * c         # delta in feet
    dMeters = rmeters * c     # delta in meters

    @distances["km"] = dKm
    @distances["ft"] = dFeet
    @distances["m"] = dMeters
    @distances["mi"] = dMi
  end

  def self.create(params, trip_params)
    Trip.destroy_all(employee_id: trip_params[:employee_id], lovedone_id: trip_params[:lovedone_id], status: 'active')
    trip = Trip.new(trip_params)
    trip.operation_mode = params[:operation_mode].present? ? params[:operation_mode] : nil
    return trip
  end

  def self.update(params, trip_params)
    if params[:employee_id] == '0'
      employee = Employee.first
    else
      employee = Employee.find(params[:employee_id])
    end

    lovedone = Lovedone.find(params[:lovedone_id])
    lovedone_id = params[:lovedone_id]
    employee_id = params[:employee_id]
    trip_id = params[:id]
    trip = Trip.find(trip_id)

    if trip_params[:status] == 'started'
      lovedone.employee_id = employee.id
      lovedone.save

      if trip_params[:start_latitude].present? and trip_params[:start_longitude].present? and trip_params[:status].present?
        trip.start_latitude = trip_params[:start_latitude]
        trip.start_longitude = trip_params[:start_longitude]
        trip.save
        # trip.travel_logs.create(latitude: trip_params[:latitude], longitude: trip_params[:longitude], employee_id: employee_id, status: trip_params[:status])
      end

      # Module which will send notification to SP, if employee click Arrival or PickUp before reaching Loved One distance threshold range
      if employee.company.zone_notification.present? and params[:operation_mode].nil?
        if employee.company.zone_notification.early_arrival_status
          distance = calculate_distance(trip_params[:start_latitude],trip_params[:start_longitude],lovedone.latitude, lovedone.longitude)
          if distance > employee.company.zone_notification.distance_threshold
            require 'open-uri'
            account_sid = Rails.application.secrets.twilio_sid
            auth_token = Rails.application.secrets.twilio_token
            @client = Twilio::REST::Client.new account_sid, auth_token

            trip.early_arrival_notification = Time.zone.now
            trip.save

            unless employee.company.zone_notification.contact_method.index('email').nil?
              early_encounter_email = SystemMailer.delay.early_encounter_email(employee.company.zone_notification.email, employee, trip.lovedone, distance)
            end

            unless employee.company.zone_notification.contact_method.index('text').nil?
              to_number = employee.company.zone_notification.phone_number
              if employee.company.notification_masking
                first_last_name = "#{lovedone.first_name} #{lovedone.last_name[0]}"
              else
                first_last_name = "#{lovedone.first_name} #{lovedone.last_name}"
              end
              body = "Early Arrival Notice - Employee: #{employee.first_name} #{employee.last_name}; Loved One: #{first_last_name}; Distance Away: #{distance.round(2)} miles"
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
        end
      end

      Timesheet.savetimesheet(lovedone_id,employee_id,trip_id)

      employee.service_status = "PickUp" if employee.company.provider_type == "Transport"
      employee.service_status = "Arrival" if employee.company.provider_type == "Home_Health"
    elsif trip_params[:status] == 'completed'
      lovedone.employee_id = ''
      lovedone.save

      if trip_params[:end_latitude].present? and trip_params[:end_longitude].present? and trip_params[:status].present?
        trip.end_latitude = trip_params[:end_latitude]
        trip.end_longitude = trip_params[:end_longitude]
        # trip.travel_logs.create(latitude: trip_params[:latitude], longitude: trip_params[:longitude], employee_id: employee_id, status: trip_params[:status])
      end

      timesheet = Timesheet.where(lovedone_id: lovedone_id, employee_id: employee_id).last()
      timesheet.endtime = Time.now
      timesheet.save
      employee.service_status = "DropOff" if employee.company.provider_type == "Transport"
      employee.service_status = "Departure" if employee.company.provider_type == "Home_Health"
    end
    if employee.save
      operation_mode = params[:operation_mode]
      if operation_mode.present?
        if operation_mode.downcase == 'handy'
          PushNotificationService.push_notification(employee)
        end
      end
      EmailService.send_emailer(employee, lovedone, operation_mode)
    end
    trip
  end

  def self.current_location(params)
    employee_id = params[:id]
    Trip.where(employee_id: employee_id, status: ['active', 'started']).update_all({end_latitude: params[:latitude], end_longitude: params[:longitude]})

    @employee = Employee.find(employee_id)
    result = @employee.update(latitude: params[:latitude], longitude: params[:longitude])

    provider_type = @employee.company.provider_type

    if provider_type.downcase == 'home_health'
      # Currently it is working for only HOME HEALTH Employees
      trips = @employee.active_trips
      trips.each do |trip|
        if trip.present?
          if trip.status.downcase == 'started'
            lovedone = trip.lovedone
            lovedone_lat = lovedone.latitude
            lovedone_lng = lovedone.longitude
            unless trip.inside_zone
              # It will calculate the distance as making current location thr source points
              distance = calculate_distance(params[:latitude],params[:longitude],lovedone_lat, lovedone_lng)
              if distance < @employee.company.zone_notification.distance_threshold
                trip.inside_zone = true
                trip.save
                next
              end
            end

            if trip.inside_zone
              # Once inside the zone, it will calculate the distance as making loved one address as source
              distance = calculate_distance(params[:latitude],params[:longitude],lovedone_lat,lovedone_lng)
              if @employee.company.zone_notification.present? and @employee.company.zone_notification.try(:system_status)
                if trip.distance_notification.nil?
                  if distance > @employee.company.zone_notification.distance_threshold
                    # If Employee cross the threshold limit, he will get notification to the registered mobile
                    PushNotificationService.push_notification(@employee, trip, 'distance_notification', 'Departure Reminder: Distance')
                  end
                elsif !(trip.notification_response)
                  # This module will work when employee does not give any response to the notification sent
                  if trip.time_notification.nil?
                    if (trip.distance_notification + (@employee.company.zone_notification.time_threshold).minutes) < Time.zone.now
                      PushNotificationService.push_notification(@employee, trip, 'time_notification', 'Departure Reminder: Time')
                    end
                  elsif trip.recurring_notification.nil?
                    if (trip.time_notification + (@employee.company.zone_notification.recurring_threshold).minutes) < Time.zone.now
                      PushNotificationService.push_notification(@employee, trip, 'recurring_notification', 'Departure Reminder: Final Time')
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  # def self.late_notice(employee, lovedone, appointment, timesheet)
  #   # Late Notice Email sending module
  #   if employee.company.late_notice_notification.present? and employee.company.late_notice_notification.system_status
  #     if appointment.count > 0 and trip.late_notice.nil?
  #       appointment_time = appointment.first.start_time.strftime('%H:%M')
  #       appointment_time_with_tardiness = (appointment.first.start_time + (employee.company.late_notice_notification.time_threshold).minutes).strftime('%H:%M')
  #       timsheet_start_time = timesheet.starttime.strftime('%H:%M')
  #       if timsheet_start_time > appointment_time_with_tardiness
  #         require 'open-uri'
  #         account_sid = ENV['TWILIO_SID']
  #         auth_token = ENV['TWILIO_TOKEN']
  #         @client = Twilio::REST::Client.new account_sid, auth_token
  #
  #         timesheet.trip.late_notice = DateTime.now
  #         timesheet.trip.save
  #
  #         unless employee.company.late_notice_notification.contact_method.index('email').nil?
  #           late_notice_email = SystemMailer.delay.late_notice_email(employee.company.late_notice_notification.email, employee, trip.lovedone, appointment_time)
  #         end
  #
  #         unless employee.company.late_notice_notification.contact_method.index('text').nil?
  #           to_number = employee.company.late_notice_notification.phone_number
  #           if employee.company.notification_masking
  #             first_last_name = "#{lovedone.first_name} #{lovedone.last_name[0]}"
  #           else
  #             first_last_name = "#{lovedone.first_name} #{lovedone.last_name}"
  #           end
  #           body = "Late Notice - Employee: #{employee.first_name} #{employee.last_name}; Loved One: #{first_last_name}; Appointment Time: #{appointment_time}"
  #           to_number = to_number.gsub(/\D/, "")
  #           if to_number.size == 10
  #             to_number = '+1' + to_number
  #
  #             @client.messages.create(
  #                 :from => ENV['TWILIO_FROM_NUMBER'],
  #                 :to => to_number,
  #                 :body => body
  #             )
  #           end
  #         end
  #       end
  #     end
  #   end
  # end
end