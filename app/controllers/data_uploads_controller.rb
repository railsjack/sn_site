class DataUploadsController < ApplicationController

  before_filter :authenticate_user!

  def index
    authorize! :read, DataUploadsController
  end

  def settings
    @company = current_user.company
  end

  def update_settings
    @company = Company.find(params[:id])
    @company.abbreviated_time = params[:company][:abbreviated_time]

    respond_to do |format|
      if @company.save
        format.html { redirect_to settings_data_uploads_path, notice: 'Updated Successfully' }
      end
    end
  end

  def new_appointment
  end

  def add_appointment
    employee_id = params[:employee_id]
    lovedone_id = params[:lovedone_id]
    @date = params[:date]
    param_start_datetime = "#{@date} #{params[:start_datetime]}"
    param_end_datetime = "#{@date} #{params[:end_datetime]}"
    start_datetime = Time.zone.parse(customized_date(param_start_datetime))
    end_datetime = Time.zone.parse(customized_date(param_end_datetime))
    timesheet = Timesheet.where("(employee_id = ? AND lovedone_id = ?) AND ((starttime < ? AND endtime > ?) OR (starttime >= ? AND starttime < ?) OR (endtime > ? AND endtime <= ?))", employee_id, lovedone_id, start_datetime, end_datetime, start_datetime, end_datetime, start_datetime, end_datetime)
    if end_datetime < start_datetime
      @time_error = true
    elsif timesheet.count > 0
      @existing_trip = true
    else
      @time_error = false
      @existing_trip = false
      trip = Trip.create(employee_id: employee_id, lovedone_id: lovedone_id, status: 'completed', operation_mode: 'Handy')
      timesheet = trip.build_timesheet(starttime: start_datetime, endtime: end_datetime, lovedone_id: lovedone_id, employee_id: employee_id, company_id: current_user.company.id, trip_id: trip)
      # timesheet.save
    end

    respond_to do |format|
      format.js
    end

  end

  def customized_date(date_time)
    date = date_time.split[0].split('/')
    time = date_time.split[1]
    datetime = "#{date[1]}/#{date[0]}/#{date[2]} #{time}"
    return datetime
  end

  def update_encounter_based
    timesheet = Timesheet.find(params[:timesheet_id])
    encounter_based = params[:encounter_based].to_bool

    timesheet.encounter_based = encounter_based
    timesheet.save

    respond_to do |format|
      format.js
    end
  end

  def data_upload_preview
    @type = params[:type]
    @alert_sd = params[:start_date]
    @alert_ed = params[:end_date]
    start_date = params[:start_date].split('/')
    @start_date = Time.parse(start_date[1] + '/' + start_date[0] + '/' + start_date[2]).strftime('%Y-%m-%d')
    end_date = params[:end_date].split('/')
    @end_date = Time.parse(end_date[1] + '/' + end_date[0] + '/' + end_date[2]).strftime('%Y-%m-%d')
    @company = current_user.company.id
    @shifts = Activity.where("DATE_FORMAT(start_time, '%Y-%m-%d') BETWEEN ? AND ? and company_id= ?", start_date, end_date, @company)
    if @type == 'billing'
      @bl_f2f = params[:bl_f2f].to_bool
    elsif @type == 'payroll'
      @pr_f2f = params[:pr_f2f].to_bool
      @pr_dtb = params[:pr_dtb].to_bool
      @pr_dmb = params[:pr_dmb].to_bool
      @pr_base_first_last = params[:pr_b_f_l].to_bool
    end
  end

  def update_upload_alert_time
    @selected_start_date = params[:selected_sd]
    @selected_end_date = params[:selected_ed]
    @pr_f2f = params[:pr_f2f]
    @pr_dtb = params[:pr_dtb]
    @pr_dmb = params[:pr_dmb]

    @alert_type = params[:alert_type]
    @comp_type = params[:comp_type]
    timesheet = Timesheet.find(params[:timesheet_id])
    start_time = params[:start_time]
    end_time = params[:end_time]

    date = timesheet.starttime.strftime('%Y-%m-%d')
    start_datetime = Time.zone.parse("#{date} #{start_time}")
    end_datetime = Time.zone.parse("#{date} #{end_time}")

    if end_datetime < start_datetime
      @time_error = true
    else
      @time_error = false
      if @comp_type == 'payroll' and @alert_type == 'end_encounter_1'
        timesheet.endtime = timesheet.trip.recurring_notification
        timesheet.trip.recurring_notification = nil
        timesheet.trip.save
        timesheet.save

      elsif @comp_type == 'payroll' and @alert_type == 'open_encounter'
        timesheet.starttime = start_datetime
        timesheet.endtime = end_datetime
        timesheet.trip.status = 'completed'
        timesheet.trip.save
        timesheet.save

      elsif @comp_type == 'payroll' and (@alert_type == 'abbreviated_time' or @alert_type == 'end_encounter_2' or @alert_type == 'open_encounter')
        # shift = Activity.find(params[:shift_id])
        # shift_start_time = params[:shift_start_time]
        # shift_end_time = params[:shift_end_time]
        #
        # shift_date = shift.start_time.strftime('%Y-%m-%d')
        # shift_start_time = Time.zone.parse("#{shift_date} #{shift_start_time}")
        # shift_end_time = Time.zone.parse("#{shift_date} #{shift_end_time}")

        # if start_time < shift_start_time
        #   shift.start_time = start_datetime
        #   shift.save
        # elsif end_time > shift_end_time
        #   shift.end_time = end_datetime
        #   shift.save
        # end

        timesheet.starttime = start_datetime
        timesheet.endtime = end_datetime
        timesheet.save
      end

    end

    respond_to do |format|
      format.js
    end
  end

  def show
    render text: 'success'
  end
end
