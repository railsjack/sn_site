class PushNotificationService
  def self.push_notification(employee, trip=nil, notification_type='', message_type='')
    if employee.device_type.present? and employee.device_type.downcase == 'android'
      # This code will work for Android notifications
      gcm = GCM.new(Rails.application.secrets.android_api_key)
      registration_ids= [employee.device_id]
      options = {data: {message: 'Account Update Notice', title: 'Safety Notice', subtitle: 'Subtitle', tickerText: 'ALERT!', tp: 9, vibrate: 1, sound: 1}}
      if trip.present?
        options[:data] = options[:data].merge({message: "#{message_type} ALERT!",tp: 8, eid: employee.id, tid: trip.id, lid: trip.lovedone.id, ln: "#{trip.lovedone.first_name} #{trip.lovedone.last_name}"})
      end
      response = gcm.send(registration_ids, options)
    elsif employee.device_type.present? and employee.device_type.downcase == 'ios'
      # This code will work for IOS notifications
      APNS.host = 'gateway.push.apple.com'
      APNS.port = 2195
      APNS.pem  = File.join(Rails.root, "/config/apple_notifications/02-06-2017_updated.pem")
      APNS.pass = ''

      device_token = employee.device_id
      if trip.present?
        status = APNS.send_notification(device_token, alert: "#{message_type} ALERT!", badge: 1, sound: 'beep.wav', other: {tp: 8, eid: employee.id, tid: trip.id, lid: trip.lovedone.id, ln: trip.lovedone.name})
      else
        status = APNS.send_notification(device_token, alert: 'Account Update Notice', badge: 1, sound: 'beep.wav', other: {tp: 9})
      end
    end
    if trip.present?
      eval("trip.#{notification_type} = DateTime.now")
      trip.save
    end
  end
end