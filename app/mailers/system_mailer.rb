class SystemMailer < ActionMailer::Base
  default from: "Contact@SafetyNotice.com <contact@safetynotice.com>"
  @@which_message = 0
  def track_email(to, employee, lovedone, sponsor, which, operation_mode, follower=nil)
    @employee = employee
    @lovedone = lovedone
    @follower = follower
    #@sponsors = Sponsor.all
    @sponsor = sponsor
    p '*'*100
    p @sponsor.inspect
    p '*'*100

    @which_message = @@which_message

    if @which_message < 2
        @@which_message = @which_message + 1
    else
        @@which_message = 0
    end
    @which_message = which
    @@which_message = which

    @operation_mode = operation_mode
    mail(to: to, subject: 'Update to your Loved One')
  end

  def follower_confirmation_email(to, lovedone)
    @lovedone = lovedone
    mail(to: to, subject: 'Update to your Loved One' )
  end

  def early_encounter_email(to, employee, lovedone, distance)
    @employee = employee
    @lovedone = lovedone
    @distance = distance
    mail(to: to, subject: 'Update of Early Encounter')
  end

  def late_notice_email(to, employee, lovedone, time)
    @employee = employee
    @lovedone = lovedone
    @time = time
    mail(to: to, subject: 'Update of Late Encounter')
  end

  def employee_appointments_schedule(to, employee, start_date, end_date)
    @employee = employee
    @start_date = start_date
    @end_date = end_date
    p "Schedule for #{employee.full_name} from #{DateTime.parse(@start_date).strftime('%m/%d/%Y')} to #{DateTime.parse(@end_date).strftime('%m/%d/%Y')}"
    mail(to: to, subject: "Schedule for #{employee.full_name} from #{DateTime.parse(@start_date).strftime('%m/%d/%Y')} to #{DateTime.parse(@end_date).strftime('%m/%d/%Y')}", from: "Health Support Team <contact@healthsupportteam.com>")
  end

  def lovedone_appointments_schedule(to, lovedone, start_date, end_date)
    @lovedone = lovedone
    @start_date = start_date
    @end_date = end_date
    p "Schedule for #{lovedone.full_name} from #{DateTime.parse(@start_date).strftime('%m/%d/%Y')} to #{DateTime.parse(@end_date).strftime('%m/%d/%Y')}"
    mail(to: to, subject: "Home Health Visit Schedule for #{lovedone.full_name}", from: "Health Support Team <contact@healthsupportteam.com>")
  end

  def follower_appointments_schedule(to, follower, start_date, end_date)
    @follower = follower
    @start_date = start_date
    @end_date = end_date
    p "Schedule for #{follower.full_name} from #{DateTime.parse(@start_date).strftime('%m/%d/%Y')} to #{DateTime.parse(@end_date).strftime('%m/%d/%Y')}"
    mail(to: to, subject: "Home Health Visit Schedule for #{follower.lovedone.full_name}", from: "Health Support Team <contact@healthsupportteam.com>")
  end

  def admin_request_email(new_member)
    @new_user = new_member
    admin_emails = User.where(role: 2).first.emails.pluck(:email)
    # to = 'contact@safetynotice.com'
    mail(to: admin_emails, subject: 'New Safety Notice Provider Request')
  end

  def invite_email(to, primary_contact_name, lovedone_name, invitation_id)
    @primary_contact_name = primary_contact_name
    @lovedone_name = lovedone_name
    @invitation_id = invitation_id
    mail(to: to, subject: 'Safety Notice Family Member Enrollment Invitation')
  end

  def receiveapp_email(to)
    mail(to: to, subject: 'SafetyNotice.com Notification Email')
  end

  def approveapp_email(to)
    mail(to: to, subject: 'SafetyNotice.com Notification Email')
  end

  def invoice_email(invoice, sender)

    @sender = sender

    @to = invoice.sponsor.email
    @title = invoice.title
    @amount = invoice.amount
    @start_date = invoice.start_date
    @end_date = invoice.end_date
    @message_count = invoice.message_count

    mail(to: @to, subject: @title)
  end
end
