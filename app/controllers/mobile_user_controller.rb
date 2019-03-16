#require 'action_view'
class MobileUserController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  #before_filter :authenticate_user!, :allow_ajax_request_from_other_domains
  skip_before_filter :verify_authenticity_token, :only => [:login, :getlovedones, :getall_lovedones, :pick_lovedone, :drop_lovedone, :updatelocation, :createtrip, :updatetrip, :deletetrip, :gettrips, :updateOnlyLocation, :employee_activity, :update_current_location, :device_registration, :notification_response, :data_syncing]
    
#=begin  
    before_filter :allow_ajax_request_from_other_domains

     def allow_ajax_request_from_other_domains
       headers['Access-Control-Allow-Origin'] = '*'
       headers['Access-Control-Request-Method'] = '*'
       headers['Access-Control-Allow-Headers'] = '*'
     end
#=end

  #for rest based access 
  #POST /api/employee/signin    
  def login
      @employee = Employee.where("username LIKE ? AND password LIKE ?", params[:username], params[:password])
      if @employee
        if @employee.count==0
          render :json=>{result: false}.to_json
        else
          @employee = @employee.first
          @company = Company.find(@employee.company_id)
          # get the last actived loved one with employee id'

          @active_trips = Trip.where(status: ['active','started'])

          active_lovedone_ids = @active_trips.pluck(:lovedone_id)
          @active_lovedones = Lovedone.where(id: active_lovedone_ids)

          render :json=>{ result: true, employee: @employee, company: @company, active_lovedones: @active_lovedones, active_trips: @active_trips }.to_json
        end
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
  end

  #/api/employee/data_syncing
  def data_syncing
    passing_params = {data: params[:data]}
    sync_status = DataSyncingService.data_syncing(passing_params)
    if sync_status
      render json: {message: 'Data Synced Successfully', status: true}
    else
      render json: {message: 'No Data for Syncing', status: false}
    end
  end

  #/api/employee/device_registration
  def device_registration
    @employee = Employee.find(params[:employee_id])
    @employee.device_id = params[:reg_id]
    @employee.device_type = params[:reg_type]
    if @employee.save
      render json: {status: 1}
    else
      render json: {message: 0}
    end
  end

  #/api/employee/activity
  def employee_activity
    employee = Employee.find(params[:employee_id])
    if params[:employee_id].present? and params[:shift_completed].blank? and params[:shift_started].blank?
      activity = Activity.where(employee_id: employee.id, shift_started: true, shift_completed: false)
      if activity.count > 0
        render json: {activity: 'shift_started', start_date: activity.first.start_time.strftime("%m-%d-%y %H:%M")}
      else
        end_date = Activity.where(employee_id: params[:employee_id]).last.end_time.strftime("%m-%d-%y %H:%M")
        render json: {activity: 'no_shift_started', end_date: end_date}
      end

    elsif params[:shift_started] == 'true'
      activity = Activity.where(employee_id: employee.id, shift_started: true, shift_completed: false)
      if activity.present?
        render json: {activity: 'shift_already_started', start_date: activity.first.start_time.strftime("%m-%d-%y %H:%M")}
      else
          new_activity = Activity.create(employee_id: employee.id, company_id: employee.company.id, shift_started: true, start_time: Time.zone.now)
          render json: {shift_started: 'shift_started', start_date: new_activity.start_time.strftime("%m-%d-%y %H:%M")}
      end

    elsif params[:shift_completed] == 'true'
      activity = Activity.where(employee_id: employee.id, shift_started: true, shift_completed: false).first
      if activity.present?
        activity.shift_completed = true
        activity.end_time = Time.zone.now
        activity.save
        render json: {activity: 'shift_completed', end_date: activity.end_time.strftime("%m-%d-%y %H:%M")}
      else
        last_activity = Activity.where(employee_id: employee.id, shift_started: true, shift_completed: true).last
        render json: {activity: 'no_shift_started', end_date: last_activity.end_time.strftime("%m-%d-%y %H:%M")}
      end

    end
  end

  #/api/employee/notification_response
  def notification_response
    trip = Trip.find(params[:trip_id])
    trip.notification_response = true

    if trip.save
      render json: {status: true}
    end
  end

  #/api/employee/:id/current_location
  include EmployeesHelper
  def update_current_location
    @result = TripService.current_location(params)

    if @result
      render json: {location: 'location updated successfully'}
    else
      render json: @result.errors, status: :unprocessable_entity
    end
  end

  #/api/employee/:id/lovedones
  def getlovedones
    employee_id = params[:id]

    @employee = Employee.find(employee_id)

    # TravelLog.create(employee_id: @employee.id, latitude: params[:latitude], longitude: params[:longitude])

    if @employee.assigned_lovedones.count > 0
      @lovedones = @employee.assigned_lovedones.order(:last_name)
    else
      @lovedones = @employee.company.lovedones.order(:last_name)
    end

    if @employee.company.lovedone_masking
      @lovedones = @lovedones.each {|loved_one| loved_one.last_name = loved_one.last_name[0]}
    end

    @active_trips = Trip.where(status: ['active','started'])
    @employees = @active_trips.pluck(:employee_id, :lovedone_id)
    @active_trips = @active_trips.pluck(:id, :lovedone_id, :status)

    if @lovedones
        render :json => {lovedones: @lovedones, employees: @employees, active_trips: @active_trips}
    else
        render json: @lovedones.errors, status: :unprocessable_entity
    end
  end

  
  #/api/employee/:id/lovedone/:id
  def pick_lovedone
    employee = Employee.find(params[:employee])
    lovedone = Lovedone.find(params[:lovedone])
    trip_id = params[:id]

    lovedone_id = lovedone.id 
    employee_id = employee.id

    Timesheet.savetimesheet(lovedone_id,employee_id,trip_id)

    employee.lovedone_id = lovedone.id

    employee.service_status = "PickUp" if employee.company.provider_type == "Transport"
    employee.service_status = "Arrival" if employee.company.provider_type == "Home_Health"

    if employee.save
      render :json => {result: true}
    else
      render :json => {result: false}
    end
  end
      
  #/api/employee/:id/lovedone/:id
  def drop_lovedone
    employee = Employee.find(params[:employee])
    
    employee.service_status = "DropOff" if employee.company.provider_type == "Transport"
    employee.service_status = "Departure" if employee.company.provider_type == "Home_Health"
    employee.save
    lovedone_id = employee.lovedone_id
    employee_id = employee.id

    Trip.where(lovedone_id: lovedone_id, status: ['completed'])

    timesheet = Timesheet.where(:lovedone_id => lovedone_id, :employee_id => employee_id).last()
    timesheet.endtime = Time.now
    timesheet.save

    employee.lovedone_id = ''
    if employee.save
      render :json => {result: true}
    end
  end

  #/api/employee/:id/trip/:trip_id/edit
  def updatelocation
    @employee = Employee.find(params[:id])
    @trip = Trip.find(params[:trip_id])
    if  @employee.update(:latitude => params[:latitude], :longitude  => params[:longitude]) &&
        @trip.update(:end_latitude => params[:end_latitude], :longitude  => params[:end_longitude])
      render :json => {result: true}
    else
      render json: {result: false}, status: :unprocessable_entity
    end
  end   

  def updateOnlyLocation
    
    Trip.where(employee_id: params[:id], status: ['active','started']).update_all({end_latitude:params[:end_latitude], end_longitude:params[:end_longitude]})

    @employee = Employee.find(params[:id])
    if  @employee.update(:latitude => params[:latitude], :longitude  => params[:longitude])
      render :json => {result: true}
    else
      render json: {result: false}, status: :unprocessable_entity
    end
  end

  def updateOnlyLocation1
    @employee = Employee.find(params[:id])
    if employee_params.key?"company"
        puts "Employee has compnay key"
        employee_params[:employee].delete :company
    end
    if employee_params.key?"updated_at"
        employee_params.delete :updated_at
    end

    respond_to do |format|
      if @employee.update(employee_params)
        @employee.touch
        puts "employee location UPDATED"
        #format.json { render json: @employee, status: :ok }
        format.json  { render :json => @employee.to_json(:include => [:company])}
      else
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  #/api/trip/new
  def createtrip
    @trip = TripService.create(params, trip_params)
    if @trip.save
      if @trip.operation_mode.present?
        if @trip.operation_mode.downcase == 'handy'
          PushNotificationService.push_notification(@trip.employee)
        end
      end
      render json: @trip, status: :ok
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  #/api/trip/update/:id
  def updatetrip
    @trip = TripService.update(params, trip_params)
    if @trip.update(trip_params)
      render json: @trip, status: :ok
    else
      render json: @trip.errors, status: :unprocessable_entity
    end
  end

  #/api/trip/delete
  def deletetrip
    operation_mode = params[:operation_mode]
    if operation_mode.present?
      if operation_mode.downcase == 'handy'
        PushNotificationService.push_notification(Trip.find(params[:id]).employee)
      end
    end
    if Trip.destroy(params[:id])
      render json: {result: true}
    else
      render json: {result: false}, status: :unprocessable_entity
    end
  end

  #/api/trips/:employee_id
  def gettrips
      @employee = Employee.find(params[:employee_id])
      @trips = Trip.where(employee_id: @employee, state: "active")
        respond_to do |format|
            if @trips
                format.json  { render :json => @trips.to_json(:include => [:lovedone, :employee])}
            else
                format.json { render json: @trips.errors, status: :unprocessable_entity }
            end
        end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:latitude, :longitude, :employee_id, :company_id, :lovedone_id, :name, :username, :password, :id, :created_at, :updated_at, :service_status)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:employee_id, :lovedone_id, :status, :state, :start_latitude, :start_longitude, :end_latitude, :end_longitude, :operation_mode)
    end

    def location_params
      params.require(:location).permit(:employee_id, :latitude, :longitude)
    end
end






