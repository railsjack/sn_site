class SchedulersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :read, Scheduler
  end

  def transfer_appointments
  end

  def appointment_transfer_text(phone, emp, start_date, end_date)
    to_number = phone
    return false if(to_number==nil)
    unless to_number.nil?
      to_number = to_number.gsub(/\D/, "")
      if to_number.size == 10
        to_number = '+1' + to_number
        account_sid = Rails.application.secrets.twilio_sid
        auth_token = Rails.application.secrets.twilio_token
        @client = Twilio::REST::Client.new account_sid, auth_token
        Time.zone = emp.company.time_zone
        text_message = "Schedule for #{emp.full_name}" + "\n\n"
        Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')>=? and DATE_FORMAT(end_time, '%Y-%m-%d')<=? and employee_id=?", start_date, end_date, emp.id).each do |appt|
          text_message += "#{appt.start_time.strftime('%m/%d/%y')}: (#{appt.start_time.strftime('%H:%M')} - #{appt.end_time.strftime('%H:%M')}); #{appt.lovedone.full_name}; "
          text_message += "#{appt.lovedone.try(:phone_number)}; "
          text_message += "#{appt.lovedone.street} #{appt.lovedone.apt_unit} #{appt.lovedone.city} #{appt.lovedone.state} #{appt.lovedone.zip_code}".tr('.', '')
          # if emp.device_type.present? and emp.device_type.downcase == 'ios'
          text_message += ' ( ' + URI::encode("http://maps.google.com/maps?z=18&t=m&q=loc:#{appt.lovedone.latitude}+#{appt.lovedone.longitude}") + ' )'
          # end
          text_message += "\n\n"
        end

        begin
          @client.messages.create(
              from: Rails.application.secrets.twilio_from_number,
              to: to_number,
              body: text_message
          )
        rescue => ex
          logger.error ex.message
        end
      end
    end
  end

  def preview_appointments
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    unless current_user.employee?
      if params[:employee_id] == '0'
        @available_appointments = Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')>=? and DATE_FORMAT(end_time, '%Y-%m-%d')<=?", @start_date, @end_date)
      else
        @available_appointments = Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')>=? and DATE_FORMAT(end_time, '%Y-%m-%d')<=? and employee_id=?", @start_date, @end_date, params[:employee_id])
      end
    else
      @available_appointments = Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')>=? and DATE_FORMAT(end_time, '%Y-%m-%d')<=? and employee_id=?", @start_date, @end_date, current_user.employee.id)
    end
  end

  def employee_send_appointments
    start_date = params[:start_date]
    end_date = params[:end_date]
    ids = params[:employee_ids]
    logs = false
    transfer_type = nil
    Employee.where(id: eval(ids)).each do |emp|
      if emp.setting.eql? 'both'
        SystemMailer.delay.employee_appointments_schedule(emp.email, emp, start_date, end_date)
        appointment_transfer_text(emp.phone_number, emp, start_date, end_date)
        logs = true
        transfer_type = 'email_text'
      elsif emp.setting.eql? 'email'
        SystemMailer.delay.employee_appointments_schedule(emp.email, emp, start_date, end_date)
        logs = true
        transfer_type = 'email'
      elsif emp.setting.eql? 'text'
        appointment_transfer_text(emp.phone_number, emp, start_date, end_date)
        logs = true
        transfer_type = 'text'
      elsif emp.setting.eql? 'off'
        logs = false
      end
      AppointmentTransfer.create(person_id: emp.id, person: 'employee', transfer_date: Time.now, company_id: current_user.company.id, transfer_type: transfer_type) if logs
    end

    respond_to do |format|
      format.js
    end
  end

  def lovedone_send_appointments
    start_date = params[:start_date]
    end_date = params[:end_date]
    lovedone_ids = params[:lovedone_ids]
    lovedone_logs = false
    lo_transfer_type = nil
    Lovedone.search_lovedones(eval(lovedone_ids)).each do |lovedone|
      if lovedone.setting.eql? 'letter'
        lovedone_logs = true
        lo_transfer_type = 'letter'
        lo_document = LobService.create_letter(lovedone, 'Loved One Sample Content', lovedone.company, start_date, end_date)
        lo_document = lo_document['url']
      elsif lovedone.setting.eql? 'email'
        SystemMailer.delay.lovedone_appointments_schedule(lovedone.email, lovedone, start_date, end_date)
        lovedone_logs = true
        lo_transfer_type = 'email'
        lo_document = ''
      elsif lovedone.setting.eql? 'off'
        lovedone_logs = false
      end
      AppointmentTransfer.create(person_id: lovedone.id, person: 'lovedone', transfer_date: Time.now, company_id: current_user.company.id, transfer_type: lo_transfer_type, document: lo_document) if lovedone_logs

      follower_logs = false
      fo_transfer_type = nil
      lovedone.followers.each do |follower|
        if follower.setting.eql? 'letter'
          fo_document = LobService.create_letter(follower, 'Follower Sample Content', follower.lovedone.company, start_date, end_date)
          fo_document = fo_document['url']
          follower_logs = true
          fo_transfer_type = 'letter'
        elsif follower.setting.eql? 'email'
          SystemMailer.delay.follower_appointments_schedule(follower.email, follower, start_date, end_date)
          follower_logs = true
          fo_transfer_type = 'email'
          fo_document = ''
        elsif follower.setting.eql? 'off'
          follower_logs = false
        end
        AppointmentTransfer.create(person_id: follower.id, person: 'follower', transfer_date: Time.now, company_id: current_user.company.id, transfer_type: fo_transfer_type, document: fo_document) if follower_logs
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def transfer_employees
    start_date = params[:start_date]
    end_date = params[:end_date]
    @available_employees = Scheduler.where("DATE_FORMAT(start_time, '%Y-%m-%d')>=? and DATE_FORMAT(end_time, '%Y-%m-%d')<=? ", start_date, end_date).pluck(:employee_id)
  end



  def late_notice_settings
    @company = current_user.company
    if @company.late_notice_notification.nil?
      @company.build_late_notice_notification
      @company.save
    end
  end

  def update_late_notice_settings
    company = current_user.company
    respond_to do |format|
      if company.update_attributes(late_notice_notification_params)
        format.html { redirect_to late_notice_settings_schedulers_path, notice: 'Updated Successfully' }
      else
        format.html { redirect_to late_notice_settings_schedulers_path, notice: 'Not Updated' }
      end
    end
  end

  def scheduler_calendar
    @employee = params[:employee_id].present? ? Employee.find(params[:employee_id]) : nil
    @lovedone = params[:lovedone_id].present? ? Lovedone.find(params[:lovedone_id]) : nil
    @company_employees = Employee.where(company_id: current_user.company.id)
    @view = params[:view].present? ? params[:view] : nil
    @current_day = params[:current_day].present? ? DateTime.strptime(params[:current_day].to_s, '%Q').strftime('%m/%d/%Y') : Date.current

    @calendar_schedules = []
    if @employee.present?
      @employee.schedulers.each do |schedule|
        @calendar_schedules.push schedule
      end
    elsif @lovedone.present?
      @lovedone.schedulers.each do |schedule|
        @calendar_schedules.push schedule
      end
    else
      @company_employees.all.each do |employee|
        employee.schedulers.each do |schedule|
          @calendar_schedules.push schedule
        end
      end
    end

    respond_to do |format|
      format.js
      format.json
    end
  end

  def schedule_options
    edit_id = params[:edit_id].present? ? params[:edit_id] : nil
    if params[:option_type] == 'precedingOption1'
      @precedingOption1 = Scheduler.create_schedule(edit_id, params[:employee], params[:lovedone], session[:start_time], session[:end_time], params[:frequency], params[:key])
      session[:prev_schedule] = session[:travel_time] = session[:start_time] = session[:end_time] = ''
    elsif params[:option_type] == 'precedingOption2'
      prev_schedule = Scheduler.find(session[:prev_schedule])
      start_time = (prev_schedule.end_time + session[:travel_time].to_i * 60).strftime('%a, %d %b %Y %H:%M')
      end_time = (DateTime.parse(start_time) + (params[:difference].to_i).minutes).strftime('%a, %d %b %Y %H:%M')
      @precedingOption2 = Scheduler.create_schedule(edit_id, params[:employee], params[:lovedone], start_time, end_time, params[:frequency], params[:key])
      session[:prev_schedule] = nil
      session[:travel_time] = nil
      session[:start_time] = nil
      session[:end_time] = nil
    elsif params[:option_type] == 'followingOption1'
      @followingOption1 = Scheduler.create_schedule(edit_id, params[:employee], params[:lovedone], session[:start_time], session[:end_time], params[:frequency], params[:key])
      session[:next_schedule] = nil
      session[:travel_time] = nil
      session[:start_time] = nil
      session[:end_time] = nil
    elsif params[:option_type] == 'followingOption2'
      next_schedule = Scheduler.find(session[:next_schedule])
      end_time = (next_schedule.start_time - session[:travel_time].to_i * 60).strftime('%a, %d %b %Y %H:%M')
      start_time = (DateTime.parse(end_time) - (params[:difference].to_i).minutes).strftime('%a, %d %b %Y %H:%M')
      @followingOption2 = Scheduler.create_schedule(edit_id, params[:employee], params[:lovedone], start_time, end_time, params[:frequency], params[:key])
      session[:next_schedule] = nil
      session[:travel_time] = nil
      session[:start_time] = nil
      session[:end_time] = nil
    elsif params[:option_type] == 'precedingFollowingOption1'
      @precedingFollowingOption1 = Scheduler.create_schedule(edit_id, params[:employee], params[:lovedone], session[:start_time], session[:end_time], params[:frequency], params[:key])
    elsif params[:option_type] == 'precedingFollowingOption2'
      start_time = session[:start_time]
      end_time = session[:end_time]
      @precedingFollowingOption2 = Scheduler.create_schedule(edit_id, params[:employee], params[:lovedone], start_time, end_time, params[:frequency], params[:key])
      session[:start_time] = nil
      session[:end_time] = nil
    end

    respond_to do |format|
      format.js
    end
  end

  def another_employee_schedule
    @frequency, @loop_number, @key = params[:frequency], params[:loop_number], params[:key]
    start_time = Time.zone.local_to_utc(DateTime.parse(session[:ae_start_time])).strftime('%Y-%m-%d %H:%M')
    end_time = Time.zone.local_to_utc(DateTime.parse(session[:ae_end_time])).strftime('%Y-%m-%d %H:%M')
    employee_ids = Scheduler.where("(start_time BETWEEN ? AND ?) OR (end_time BETWEEN ? AND ?)", start_time, end_time, start_time, end_time).pluck(:employee_id)
    @param_s_time = DateTime.parse(session[:ae_start_time]).strftime('%m/%d/%Y %H:%M')
    @param_e_time = DateTime.parse(session[:ae_end_time]).strftime('%m/%d/%Y %H:%M')
    @type = params[:type]
    if @type == 'employee'
      @prev_employee = params[:id]
      @lovedone = params[:selected_id]
    elsif @type == 'lovedone'
      @prev_employee = params[:selected_id]
      @lovedone = params[:id]
    end
    employee_ids = employee_ids.present? ? employee_ids += [@prev_employee.to_i] : [@prev_employee.to_i]
    remaining_after_overlap_employees = Employee.where("id NOT IN (?) AND company_id=?", employee_ids, current_user.company.id).pluck(:id)
    remaining_after_restricted_employees = EmployeeLovedone.where("lovedone_id = ?", @lovedone).pluck(:employee_id)
    non_restricted_employees = Employee.joins('LEFT JOIN employee_lovedones ON employees.id = employee_lovedones.employee_id').where('employee_lovedones.employee_id IS NULL AND employees.company_id=?', current_user.company.id).pluck(:id)
    array = non_restricted_employees + remaining_after_restricted_employees
    array = array - employee_ids
    array.compact.uniq!
    @available_emp = Employee.where('id in (?)', array)
  end

  def new_schedule
    @type = params['type']
    @another_employee_request = params[:employee_request].present? ? params[:employee_request] : nil
    if @type == 'employee'
      edit_id, @employee, @lovedone = params[:edit_id], params[:id], params[:selected_id]
      existing_type = nil
    elsif @type == 'lovedone'
      edit_id, @employee, @lovedone = params[:edit_id], params[:selected_id], params[:id]
      existing_type = 1
    end
    @p_start_time, @p_end_time, @loop_number, @frequency_type = params[:start_time], params[:end_time], params[:loop_number], params[:frequency].to_i
    @key = params[:key].present? ? params[:key] : Scheduler.frequency_key

    @edit_schedule_id = edit_id.present? ? edit_id : nil
    @s_datetime, @e_datetime =  Scheduler.schedule_datetime(@p_start_time), Scheduler.schedule_datetime(@p_end_time)
    @existing_schedules = Scheduler.existing_schedules(@employee, @lovedone, @s_datetime.second, @e_datetime.second, [@edit_schedule_id])
    if @existing_schedules.count == 1
      @existing_name = existing_type.present? ? @existing_schedules.first.employee.full_name : @existing_schedules.first.lovedone.full_name
      @existing_schedules = @existing_schedules.count
    else
      @existing_schedules = @existing_schedules.count
    end
    # @existing_lovedone_schedule = Scheduler.existing_lovedone_schedules(@lovedone, @s_datetime.second, @e_datetime.second, [@edit_schedule_id])
    subject_lovedone = Lovedone.find(@lovedone)
    preceding_schedule = Scheduler.present_day_schedules(@employee, @s_datetime.second.strftime("%m-%d-%Y"), [@edit_schedule_id]).preceding_schedule(@s_datetime.second)
    following_schedule = Scheduler.present_day_schedules(@employee, @e_datetime.second.strftime("%m-%d-%Y"), [@edit_schedule_id]).following_schedule(@e_datetime.second)
    preceding_schedule_lovedone, following_schedule_lovedone =preceding_schedule.try(:lovedone), following_schedule.try(:lovedone)
    @preceding_following_both = nil

    if @existing_schedules.zero?
      if preceding_schedule_lovedone.present? and following_schedule_lovedone.present? and subject_lovedone.present?
        # Subject Appointment exists in middle of preceding and following appointments
        @preceding_both = Scheduler.schedule_distance_calculation(preceding_schedule_lovedone.latitude, preceding_schedule_lovedone.longitude, subject_lovedone.latitude, subject_lovedone.longitude)
        @following_both = Scheduler.schedule_distance_calculation(subject_lovedone.latitude, subject_lovedone.longitude, following_schedule_lovedone.latitude, following_schedule_lovedone.longitude)
        selected_appt_time = TimeDifference.between(@s_datetime.first, @e_datetime.first).in_minutes
        preceding_time_comparison = DateTime.parse((preceding_schedule.end_time + @preceding_both*60).strftime('%a, %d %b %Y %H:%M:%S'))
        following_time_comparison = DateTime.parse(@e_datetime.first) + (@following_both).minutes
        if preceding_time_comparison > DateTime.parse(@s_datetime.first) and following_time_comparison > DateTime.parse((following_schedule.start_time).strftime('%a, %d %b %Y %H:%M:%S'))
          # If travel time is inadequate for both
          @preceding_following_both = true
          start_time = (preceding_schedule.end_time + @preceding_both * 60).strftime('%a, %d %b %Y %H:%M')
          end_time = (following_schedule.start_time - @following_both * 60).strftime('%a, %d %b %Y %H:%M')
          @remaining_appt_time = TimeDifference.between(start_time, end_time).in_minutes
          @subject_following_travel_time, @preceding_subject_travel_time = @following_both, @preceding_both
          session[:start_time] = start_time
          session[:end_time] = end_time
          session[:ae_start_time] = @s_datetime.first
          session[:ae_end_time] = @e_datetime.first
        elsif preceding_time_comparison > DateTime.parse(@s_datetime.first)
          # If travel time is inadequate for preceding
          p_s_travel_time = Scheduler.schedule_distance_calculation(preceding_schedule_lovedone.latitude, preceding_schedule_lovedone.longitude, subject_lovedone.latitude, subject_lovedone.longitude)
          if DateTime.parse((preceding_schedule.end_time + p_s_travel_time*60).strftime('%a, %d %b %Y %H:%M:%S')) > DateTime.parse(@s_datetime.first)
            @preceding_subject_travel_time, @prev_schedule = p_s_travel_time, preceding_schedule.id
            session[:prev_schedule] = preceding_schedule.id
            session[:travel_time] = @preceding_subject_travel_time
            session[:start_time] = @s_datetime.first
            session[:end_time] = @e_datetime.first
          else
            Scheduler.create_schedule(@edit_schedule_id, @employee, @lovedone, @s_datetime.first, @e_datetime.first, @frequency_type, @key)
          end
        elsif following_time_comparison > DateTime.parse((following_schedule.start_time).strftime('%a, %d %b %Y %H:%M:%S'))
          # If travel time is inadequate for following
          s_f_travel_time = Scheduler.schedule_distance_calculation(subject_lovedone.latitude, subject_lovedone.longitude, following_schedule_lovedone.latitude, following_schedule_lovedone.longitude)
          if DateTime.parse(@e_datetime.first) + (s_f_travel_time).minutes > DateTime.parse((following_schedule.start_time).strftime('%a, %d %b %Y %H:%M:%S'))
            @subject_following_travel_time, @next_schedule = s_f_travel_time, following_schedule.id
            session[:next_schedule] = following_schedule.id
            session[:travel_time] = @subject_following_travel_time
            session[:start_time] = @s_datetime.first
            session[:end_time] = @e_datetime.first
          else
            Scheduler.create_schedule(@edit_schedule_id, @employee, @lovedone, @s_datetime.first, @e_datetime.first, @frequency_type, @key)
          end
        else
          @following_both = @preceding_both = nil
          Scheduler.create_schedule(@edit_schedule_id, @employee, @lovedone, @s_datetime.first, @e_datetime.first, @frequency_type, @key)
        end

      elsif preceding_schedule_lovedone.present? and subject_lovedone.present?
        # only if preceding appointment exists
        p_s_travel_time = Scheduler.schedule_distance_calculation(preceding_schedule_lovedone.latitude, preceding_schedule_lovedone.longitude, subject_lovedone.latitude, subject_lovedone.longitude)
        if DateTime.parse((preceding_schedule.end_time + p_s_travel_time*60).strftime('%a, %d %b %Y %H:%M:%S')) > DateTime.parse(@s_datetime.first)
          @preceding_subject_travel_time, @prev_schedule = p_s_travel_time, preceding_schedule.id
          session[:prev_schedule] = preceding_schedule.id
          session[:travel_time] = @preceding_subject_travel_time
          session[:start_time] = @s_datetime.first
          session[:end_time] = @e_datetime.first
        else
          Scheduler.create_schedule(@edit_schedule_id, @employee, @lovedone, @s_datetime.first, @e_datetime.first, @frequency_type, @key)
        end

      elsif following_schedule_lovedone.present? and subject_lovedone.present?
        # only if following appointment exists
        s_f_travel_time = Scheduler.schedule_distance_calculation(subject_lovedone.latitude, subject_lovedone.longitude, following_schedule_lovedone.latitude, following_schedule_lovedone.longitude)
        if DateTime.parse(@e_datetime.first) + (s_f_travel_time).minutes > DateTime.parse((following_schedule.start_time).strftime('%a, %d %b %Y %H:%M:%S'))
          @subject_following_travel_time, @next_schedule = s_f_travel_time, following_schedule.id
          session[:next_schedule] = following_schedule.id
          session[:travel_time] = @subject_following_travel_time
          session[:start_time] = @s_datetime.first
          session[:end_time] = @e_datetime.first
        else
          Scheduler.create_schedule(@edit_schedule_id, @employee, @lovedone, @s_datetime.first, @e_datetime.first, @frequency_type, @key)
        end
      else
        Scheduler.create_schedule(@edit_schedule_id, @employee, @lovedone, @s_datetime.first, @e_datetime.first, @frequency_type, @key)
      end
    end
  end

  def existing_schedules
    @existing_schedules, @existing_name, @s_datetime, @e_datetime, @loop_number = params[:existing_schedules].to_i, params[:existing_name], DateTime.parse(params[:start_time]), DateTime.parse(params[:end_time]), params[:loop_number]
    @frequency_type, @key, @type = params[:frequency_type], params[:key], params[:type]
    @id, @selected_id = params[:id], params[:selected_id]
    @stop_request = true

    if @frequency_type == '2'
      if @loop_number.to_i + 1 < 7 and (@s_datetime + 1.day).wday != 0 and (@s_datetime + 1.day).wday != 6
        @loop_number, @stop_request, @p_start_time, @p_end_time = @loop_number.to_i + 1, false, (@s_datetime + 1.day), (@e_datetime + 1.day)
      else
        @stop_request = true
      end
    elsif @frequency_type == '3'
      if @loop_number.to_i + 1 < 7
        @loop_number, @stop_request, @p_start_time, @p_end_time = @loop_number.to_i + 1, false, (@s_datetime + 1.day), (@e_datetime + 1.day)
      else
        @stop_request = true
      end
    elsif @frequency_type == '4'
      if @loop_number.to_i + 1 < 7 and ((@s_datetime + 2.day).wday == 3 or (@s_datetime + 2.day).wday == 5)
        @loop_number, @stop_request, @p_start_time, @p_end_time = @loop_number.to_i + 2, false, (@s_datetime + 2.day), (@e_datetime + 2.day)
      else
        @stop_request = true
      end
    elsif @frequency_type == '5'
      if @loop_number.to_i + 1 < 7 and (@s_datetime + 2.day).wday == 4
        @loop_number, @stop_request, @p_start_time, @p_end_time = @loop_number.to_i + 2, false, (@s_datetime + 2.day), (@e_datetime + 2.day)
      else
        @stop_request = true
      end
    elsif @frequency_type == '6'
      if @loop_number.to_i + 1 < 30 and (@s_datetime + 1.day).wday != 0 and (@s_datetime + 1.day).wday != 6
        @loop_number, @stop_request, @p_start_time, @p_end_time = @loop_number.to_i + 1, false, (@s_datetime + 1.day), (@e_datetime + 1.day)
      elsif @loop_number.to_i + 3 < 30 and (@s_datetime + 3.day).wday == 1
        @loop_number, @stop_request, @p_start_time, @p_end_time = @loop_number.to_i + 3, false, (@s_datetime + 3.day), (@e_datetime + 3.day)
      else
        @stop_request = true
      end
    elsif @frequency_type == '7'
      if @loop_number.to_i + 1 < 30
        @loop_number, @stop_request, @p_start_time, @p_end_time = @loop_number.to_i + 1, false, (@s_datetime + 1.day), (@e_datetime + 1.day)
      else
        @stop_request = true
      end
    end
  end

  def edit_schedule
    @schedule = Scheduler.find(params[:id])
    if @schedule.present?
      @employee = @schedule.employee.id
      @lovedone = @schedule.lovedone.id
      @duration = params[:duration]
      if params[:type] == 'drag'
        @new_s_time = (@schedule.start_time + @duration.to_i.minutes).strftime('%Y-%m-%d %H:%M')
        @new_e_time = (@schedule.end_time + @duration.to_i.minutes).strftime('%Y-%m-%d %H:%M')
      elsif params[:type] == 'resize'
        @new_s_time = @schedule.start_time.strftime('%Y-%m-%d %H:%M')
        @new_e_time = (@schedule.end_time + @duration.to_i.minutes).strftime('%Y-%m-%d %H:%M')
      end
    end
  end

  def delete_schedule
    if params[:schedule_id].present?
      if params[:type] == '1'
        schedule = Scheduler.find(params[:schedule_id])
        freq_schedules = Scheduler.where("start_time >= ? ",schedule.start_time).where(key: schedule.key).destroy_all
      elsif params[:type] == '2'
        Scheduler.find(params[:schedule_id]).destroy
      end
    end
    render text: "true"
  end

  private

    def late_notice_notification_params
      params.require(:company).permit(late_notice_notification_attributes: [:system_status, :time_threshold, :email, :phone_number, {contact_method: []}, :id])
    end

end
