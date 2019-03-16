class EmailService
  def self.send_emailer(employee, lovedone, operation_mode, sync_mode=nil)
    @employee = employee
    @lovedone = lovedone
    approved_followers = lovedone.followers
    # sponsor_sms_count = Sponsor.sms.count
    sponsor_sms_count = Sponsor.count
    sponsor = nil
    if @lovedone.company.sponsor.present?
      sponsor = @lovedone.company.sponsor
    end
    if @lovedone.county.present? and sponsor.nil?
      result = Sponsor.where('nation = ? AND county = ?', 'County', @lovedone.county)
      sponsor = result.present? ? result.first : nil
    end
    if @lovedone.state.present? and sponsor.nil?
      result = Sponsor.where('nation = ? AND state = ?', 'State', @lovedone.state)
      sponsor = result.present? ? result.first : nil
    end
    if sponsor.nil?
      result = Sponsor.where('nation = ?', 'National')
      sponsor = result.present? ? result.first : nil
    end
    which = Random.rand(3)

    # i = 0
    follower = approved_followers.first
    # while i<sponsor_sms_count do
    #   break if sponsor.nil?
    #   sponsor = Sponsor.sms.next(sponsor.id)
    #   i = i + 1
    # end

    unless employee.company.contact_method.index('email').nil?
      if employee.company.get_notification
        provider_email = employee.company.user.email
        track_mail = SystemMailer.delay.track_email(provider_email, @employee, @lovedone, nil, which, operation_mode)
      end
    end

    approved_followers.each do |follower|
      message_status = false
      track_message_mail = SystemMailer.track_email(follower.email, @employee, @lovedone, sponsor, which, operation_mode, follower)
      mail_message = track_message_mail.body.to_s

      unless follower.contact_method_setting.eql? 'no_contact'
        if ['contact_email', 'both'].include? follower.contact_method_setting
          track_mail = SystemMailer.delay.track_email(follower.email, @employee, @lovedone, sponsor, which, operation_mode, follower)
          message_status = true
          sponsor_id = 0
          sponsor_id = sponsor.id if !sponsor.nil? && !sponsor.id.nil?
          begin
            notification = Notification.create(employee: @employee, lovedone: lovedone, sponsor_id: sponsor_id,
                                               follower: follower,primary_contact: nil, status: @employee.service_status , notification_type: "email")
          rescue => ex
            logger.error ex.message
          end
        end

        if ['contact_text', 'both'].include? follower.contact_method_setting
          to_number = follower.phone_number
          return false if(to_number==nil)
          unless to_number.nil?
            to_number = to_number.gsub(/\D/, "")
            if to_number.size == 10
              to_number = '+1' + to_number
              account_sid = Rails.application.secrets.twilio_sid
              auth_token = Rails.application.secrets.twilio_token
              @client = Twilio::REST::Client.new account_sid, auth_token
              mail_message = mail_message.gsub!(/\n/,' ')
              mail_message = mail_message.gsub('<a href="','')
              mail_message = mail_message.gsub('">link</a>','')
              mail_message = mail_message.gsub('&nbsp;','  ')
              # mail_message = mail_message.gsub('<p>','')
              # mail_message = mail_message.gsub('</p>','')
              # mail_message = mail_message.gsub('</strong>','')
              # mail_message = mail_message.gsub('<strong>','')
              # mail_message = mail_message.gsub('<br>','')
              mail_message = mail_message.gsub('&amp;','&')
              mail_message = mail_message.gsub(',',' ')
              mail_message = ActionView::Base.full_sanitizer.sanitize(mail_message)
              mail_message = mail_message.gsub('   ','')
              10.times{ mail_message = mail_message.gsub('  ',' ') }
              # mail_message = mail_message.split(' ')[0..-2].join(' ')+'.'
              begin
                puts 'send message ============================================='
                puts "sponsor: #{sponsor.inspect}"
                @client.messages.create(
                    :from => Rails.application.secrets.twilio_from_number,
                    :to => to_number,
                    :body => mail_message
                )
                message_status = true
              rescue => ex
                p 'error'
              end
            end
          end

          i = 0
          while i<sponsor_sms_count do
            break if sponsor.nil?
            sponsor = Sponsor.sms.next(sponsor.id)
            # break if sponsor.contains_people?(follower.user.profile)
            i = i + 1
          end

        end
        if message_status
          # Saving log when email or text is sent including Sponsor
          if sponsor.present?
            p '*****************************SPONSOR'
            SponsorMessage.create(sponsor: sponsor, company: @employee.company, employee: @employee, lovedone: @lovedone, follower: follower, date: Time.now)
            p '*****************************SPONSOR'
          end
        end
      end
    end
  end
end