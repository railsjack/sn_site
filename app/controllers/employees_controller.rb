class EmployeesController < ApplicationController
  before_filter :authenticate_user!, :except => [:track_employee]
  before_action :set_employee
  helper_method :lovedone_name

  def index
    authorize! :read, Employee
    @employees = Employee.sortemployeebyname(@company.id)
  end

  def admin_employees
    @employees = Employee.all
  end

  def lovedone_name(lovedone_id)
    lovedone = Lovedone.where(id: lovedone_id).select(:first_name, :last_name)
    name = ""
    lovedone.each do |loved|
      name =loved.last_name+', '+loved.first_name
    end
    return name
  end

  def rep_by_emp
    authorize! :read_report, Employee

    @title = "Report for #{@company.business_name}"
    @from = Time.zone.now - 30
    @to = Time.zone.now
    @reports = []
    if !params[:timesheet].nil? && !params[:timesheet]['starttime(1i)'].nil?
      from = params[:timesheet]['starttime(1i)']+"-"+params[:timesheet]['starttime(2i)']+"-"+params[:timesheet]['starttime(3i)']
      to = params[:timesheet]['endtime(1i)']+"-"+params[:timesheet]['endtime(2i)']+"-"+params[:timesheet]['endtime(3i)']
      @from = from.to_date if Date.valid_date? *from.split('-').map(&:to_i)
      @to = to.to_date if Date.valid_date? *to.split('-').map(&:to_i)
      @reports = Timesheet.report_by_employee(@company, @from, @to)
    else
      @init_page = true
    end
    @timesheet = Timesheet.new
  end

  def rep_by_lovedone
    @title = "Report for #{@company.business_name}"
    @from = Time.zone.now - 30
    @to = Time.zone.now
    @lovedones = []
    if !params[:timesheet].nil? && !params[:timesheet]['starttime(1i)'].nil?
      from = params[:timesheet]['starttime(1i)']+"-"+params[:timesheet]['starttime(2i)']+"-"+params[:timesheet]['starttime(3i)']
      to = params[:timesheet]['endtime(1i)']+"-"+params[:timesheet]['endtime(2i)']+"-"+params[:timesheet]['endtime(3i)']
      @from = from.to_date if Date.valid_date? *from.split('-').map(&:to_i)
      @to = to.to_date if Date.valid_date? *to.split('-').map(&:to_i)
      @lovedones = Timesheet.report_by_lovedone(@company, @from, @to)
    else
      @init_page = true
    end
    @timesheet = Timesheet.new
  end

  def travel_history
    @company = Company.find(params[:company_id])
    @employees = @company.employees.order('last_name ASC')
    @timesheet = Timesheet.new

  #   For default render page of travel history map
    @start_lat = @company.latitude
    @start_lng = @company.longitude
    @end_lat = 0
    @end_lng = 0
    @leg_color = 'black'
    @default = 'true'
    @business_name = @company.business_name
  end

  def travel_history_results
    @start_date = "#{params[:start_date].split('-')[1]}/#{params[:start_date].split('-')[2]}/#{params[:start_date].split('-')[0]}"
    @end_date = "#{params[:end_date].split('-')[1]}/#{params[:end_date].split('-')[2]}/#{params[:end_date].split('-')[0]}"
    @employee_id = params[:emp_id]
    @company_id = params[:cmp_id]
    @company = Company.find(params[:cmp_id])
    @results = Activity.where("DATE_FORMAT(start_time, '%Y-%m-%d') BETWEEN ? AND ? and employee_id = ?",  params[:start_date], params[:end_date], params[:emp_id])

    #   For default render page of travel history map
    @employee_string = '* No Leg Selected'
    @start_lat = @company.latitude
    @start_lng = @company.longitude
    @end_lat = 0
    @end_lng = 0
    @leg_color = 'black'
    @default = 'true'
    @business_name = @company.business_name
    # @results = Timesheet.where( "DATE_FORMAT(starttime, '%m/%d/%Y') >= ? and DATE_FORMAT(endtime, '%m/%d/%Y') <= ? and employee_id = ? and company_id = ?",  params[:start_date], params[:end_date], params[:emp_id], params[:cmp_id])

  end

  def travel_history_map
    @my_array = []
    if params[:present_date] and params[:emp_id]
      Timesheet.where("DATE_FORMAT(starttime, '%m-%d-%Y') >= ? and employee_id = ?", params[:present_date], params[:emp_id]).each do |timesheet|

        if timesheet.trip.present?
          if timesheet.trip.travel_logs.present?
            if timesheet.trip.travel_logs.first.latitude.present?
              @my_array += [[timesheet.trip.travel_logs.first.latitude , timesheet.trip.travel_logs.first.longitude] , [timesheet.trip.travel_logs.last.latitude , timesheet.trip.travel_logs.last.longitude]]
            end
          end
        end
      end
    end
    # @my_array = [['city', 'number'], ['nyc', 39], ['queens', 98]]
    @employee_string = params[:emp_string]
    @start_lat = params[:start_lat]
    @start_lng = params[:start_lng]
    @end_lat = params[:end_lat]
    @end_lng = params[:end_lng]
    @leg_color = params[:leg_color]
    @business_name = ''
  end

  def active_lo_update
    @employees_updated = Employee.sortemployeebyname(@company.id)
  end

  def get_locations
    if params[:lovedone_id]
      lovedone = Lovedone.find_by_id(params[:lovedone_id].to_i)
      @lat = lovedone.latitude
      @lng = lovedone.longitude
      @address = ""
      @address += "#{lovedone.apt_unit} " if lovedone.apt_unit
      @address += "#{lovedone.street}," if lovedone.street
      @address += " #{lovedone.city}," if lovedone.city
      @address += " #{lovedone.state} #{lovedone.zip_code}"
    end

    if (params[:location_type] == 'base') or (params[:location_type] == 'lovedone')
      @employees = @company.employees;
    else
      @employees = @company.employees.onlined_employees;
    end

    @hash = Gmaps4rails.build_markers(@employees) do |employee, marker|

      if params[:lovedone_id]
        lovedone = Lovedone.find_by_id(params[:lovedone_id].to_i)
        lovedone_distance = "<p class='map-info'><strong>Distance to Loved One :</strong> #{employee.distance_to_lovedone(lovedone).round(2)} miles</p>"
      end
      employee_designation = "<p class='map-info'><strong>Designation:</strong> #{employee.designation.present? ? employee.designation.name : 'None'}</p>"

      icon_name = employee.first_name.present? ? employee.first_name[0] : ''
      icon_name += employee.last_name.present? ? employee.last_name[0] : ''

      icon_color = employee.designation.present? ? Color::CSS[employee.designation.color].html.gsub('#', '') : Color::CSS['white'].html.gsub('#', '')

      if (params[:location_type] == 'base') or (params[:location_type] == 'lovedone')
        if employee.base_latitude and employee.base_longitude
          marker.lat employee.base_latitude
          marker.lng employee.base_longitude
          if params[:lovedone_id]
            marker.infowindow "<p class='map-info'><strong>Employee:</strong> <empname>" + employee.name + "</empname></p>" + employee_designation + lovedone_distance
          else
            marker.infowindow "<p class='map-info'><strong>Employee:</strong> <empname>" + employee.name + "</empname></p>" + employee_designation
          end
          marker.json empname: employee.name, iconname: icon_name, iconcolor: icon_color
        end
      else
        if employee.latitude and employee.longitude
          marker.lat employee.latitude
          marker.lng employee.longitude
          if params[:lovedone_id]
            marker.infowindow "<p class='map-info'><strong>Employee:</strong> <empname>" + employee.name + "</empname></p>" + employee_designation + lovedone_distance
          else
            marker.infowindow "<p class='map-info'><strong>Employee:</strong> <empname>" + employee.name + "</empname></p>" + employee_designation
          end
          marker.json empname: employee.name, iconname: icon_name, iconcolor: icon_color
        end
      end
    end
    @hash = @hash.select { |h| h[:lat] }

    respond_to do |format|
      if @hash
        format.json { render json: @hash }
        format.js
      else
        format.js
        format.json { render json: @hash.errors, status: :unprocessable_entity }
      end
    end
  end

  def track_locations
    authorize! :track, Employee
  end

  def track
    comuserid = @company.user_id
    @profiles = Profile.all
    @tuserp = ''
    @current_userid = "current_user.id"
    @default_zipcode = @company.zip
    @employees = @company.employees.onlined_employees
    empcount = 1
    @hash = Gmaps4rails.build_markers(@employees) do |employee, marker|
      lovedone_name_str = ""
      lovedone_name_str = "<p class='map-info'><strong>Loved one:</strong> #{employee.lovedones.pluck(:last_name, :first_name).join(", ")}</p>" unless employee.lovedones.count==0
      if employee.latitude && employee.longitude
        marker.lat employee.latitude
        marker.lng employee.longitude
        marker.infowindow "<p class='map-info'><strong>Employee:</strong> <empname>" + employee.name + "</empname></p>" + lovedone_name_str
        marker.json empname: employee.name, empnum: empcount
        empcount += 1
      end
    end
    @hash = @hash.select { |h| h[:lat] }
    respond_to do |format|
      if @hash
        format.html
        format.json { render json: @hash }
      else
        format.html
        format.json { render json: @hash.errors, status: :unprocessable_entity }
      end
    end
  end

  def track_employee
    @employee = Employee.find(params[:id])
    @lovedone = params[:l]
    trip = Trip.where(employee_id: @employee.id, lovedone_id: params[:l], status: 'started')

    if (@employee.updated_at > Time.zone.now-10.seconds) and (trip.count > 0)
      @updated_employee = @employee
    else
      @updated_employee = nil
    end

    @employees = [@updated_employee]
    @hash = Gmaps4rails.build_markers(@employees) do |employee, marker|
      if employee.present?
        if employee.latitude && employee.longitude
          marker.lat employee.latitude
          marker.lng employee.longitude
          marker.infowindow "<p class='map-info'><strong>Employee:</strong> " + employee.name + "</p>"
        end
      end
    end
    @hash = @hash.select { |h| h[:lat] }
    respond_to do |format|
      if @hash
        format.html
        format.json { render json: @hash }
      else
        format.html
        format.json { render json: @hash.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def new
    @employee = @company.employees.build
  end

  def edit
    @employee = @company.employees.find(params[:id])
  end

  def create
    @employee = @company.employees.create(employee_params)
    username = employee_params[:username]
    password = employee_params[:password]
    email = employee_params[:email]

    respond_to do |format|
      if @employee.save
        update_coordinates
        if username.present?
          @employee.create_user(username: username, email: email, password: password, password_confirmation: password, role: 'employee', company: @company, confirmed_at: Time.now)
        end
        format.html { redirect_to company_employees_url(@company), notice: 'Employee has been successfully created.' }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @employee = @company.employees.find(params[:id])
    temp_params = employee_params
    if temp_params[:password] == ''
      temp_params.delete :password
    end
    username = employee_params[:username]
    password = employee_params[:password].present? ? employee_params[:password] : nil
    email = employee_params[:email]

    respond_to do |format|
      if @employee.update(temp_params)
        update_coordinates

        if @employee.user.present?
          user = @employee.user
          user.skip_reconfirmation!
          user.update(username: username, email: email, password: password, password_confirmation: password)
        elsif username.present?
          @employee.create_user(username: username, email: email, password: password, password_confirmation: password, role: 'employee', company: @company, confirmed_at: Time.now)
        end

        if current_user.admin?
          format.html { redirect_to admin_employees_path, notice: 'Employee has been successfully updated.' }
        else
          format.html { redirect_to company_employees_url(@company), notice: 'Employee has been successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee = @company.employees.find(params[:id])

    @employee.destroy
    respond_to do |format|
      if current_user.admin?
        format.html { redirect_to admin_employees_path, notice: 'Employee has been successfully deleted.' }
      else
        format.html { redirect_to company_employees_url, notice: 'Employee has been successfully deleted.' }
      end
      format.json { head :no_content }
    end
  end

  def search_by_params
    require 'geokit'
    distance = params[:distance]
    address = params[:address]
    if distance.nil?
      distance = 0
    else
      distance = distance.to_f
    end
    designation_id = params[:designation_id]
    designation_ids = designation_id.split(',')

    @employees = @company.employees

    if address.nil?
    else
      loc = Geokit::Geocoders::GoogleGeocoder.geocode(address)
      @employees1 = @employees.onlined_employees
      @employees = []

      if loc.success
        latitude = loc.lat # => -26.30101
        longitude = loc.lng # => -48.8452974
        @employees1.each do |employee|
          flag = false
          designation_ids.each do |category|
            unless category.to_i != employee.designation_id
              flag = true
              break
            end
          end
          next unless flag
          employee_latitude = employee.latitude ? employee.latitude : 0
          employee_longitude = employee.longitude ? employee.longitude : 0
          within = @company.haversine_distance(employee_latitude, employee_longitude, latitude, longitude)
          @employees << employee if within<=distance
        end
      end
    end

    respond_to do |format|
      format.json
    end
  end

  def import_bulkdata
    @service_providers = Company.all
  end

  def import
    service_provider_id = params[:service_provider]
    formats = [".csv", ".xls", ".xlsx"]
    if formats.include?(File.extname(params[:file].original_filename))
      employees = Employee.import(params[:file], service_provider_id)
      redirect_to admin_employees_path, notice: 'Employee Imported Successfully.'
    else
      redirect_to import_employees_path, alert: 'Unknown File Format'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    begin
      @company = Company.find(params[:company_id])
      @employee = Employee.find(params[:id]) unless params[:id].nil?
    rescue
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:latitude, :longitude, :company_id, :lovedone_id,
                                     :first_name, :last_name, :address, :state, :county, :city, :zip, :username, :password, :service_status, :company_category_id,
                                     :distance, :phone_number, :email, :designation_id, :setting)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_trip
    @trip = Trip.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def trip_params
    params.require(:trip).permit(:employee_id, :lovedone_id, :status, :state, :latitude, :longitude)
  end

  def update_coordinates
      coordinates = Geokit::Geocoders::GoogleGeocoder.geocode("#{@employee.address}, #{@employee.city}, #{@employee.county}, #{@employee.state} #{@employee.zip} ")
      @employee.base_latitude = coordinates.lat
      @employee.base_longitude = coordinates.lng
      @employee.save
  end
end
