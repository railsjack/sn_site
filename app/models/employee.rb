class Employee < ActiveRecord::Base
  audited except: [:distance, :base_latitude, :base_longitude, :latitude, :longitude, :service_status, :device_type, :device_id, :lovedone_id, :company_id, :name_no_use, :deleted_at]
  acts_as_paranoid
  belongs_to :company
  belongs_to :designation
  belongs_to :user, dependent: :destroy

  scope :onlined_employees, -> { where("updated_at > ?", Time.zone.now-2.minutes) }

  has_many :sponsor_messages
  has_many :timesheet
  has_many :lovedones
  has_many :employee_lovedones, dependent: :destroy
  has_many :assigned_lovedones, through: :employee_lovedones, source: :lovedone
  has_many :schedulers, dependent: :destroy
  has_many :travel_logs
  has_many :activities
  has_many :trips, dependent: :destroy
  has_many :active_trips,  -> { where("status = 'started' or status = 'active'")}, class_name: 'Trip'

  before_save :before_save_data

  validates :username, uniqueness_without_deleted: true, allow_blank: true
  validates :email, uniqueness_without_deleted: true, allow_blank: true
  validates :first_name, presence: true

  enum setting: [:off, :email, :text, :both]

  def name
    return first_name if last_name.blank?
    "#{last_name}, #{first_name}"
  end

  def full_name
    return first_name if last_name.blank?
    "#{first_name} #{last_name}"
  end

  def self.sortemployeebyname(company_id)
    return Employee.where(company_id: company_id).order('last_name ASC')
  end

  def distance_to_company
    emp_lat = no_nil(latitude)
    emp_lng = no_nil(longitude)
    company_lat = no_nil(company.latitude)
    company_lng = no_nil(company.longitude)
    company.haversine_distance(emp_lat, emp_lng, company_lat, company_lng)
  end

  def distance_to_lovedone(lovedone)
    emp_lat = no_nil(base_latitude)
    emp_lng = no_nil(base_longitude)
    lovedone_lat = no_nil(lovedone.latitude)
    lovedone_lng = no_nil(lovedone.longitude)
    company.haversine_distance(emp_lat, emp_lng, lovedone_lat, lovedone_lng)
  end

  def self.axxess_import(file, service_provider_id)
    if file.content_type.split('/').second == 'csv'
      CSV.foreach(file.path, headers: true) do |row|
        employee = row.to_hash
        temp_import_employee(
            employee["First Name"], employee["Last Name"], employee["Address"], employee["City"],
            employee["County"], employee["State"], employee["Zip Code"], employee["Username"],
            employee["Password"], employee["Mobile Phone"], employee["Email"], employee["Designation"], service_provider_id
        )
      end
    else
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(2)
      (3..spreadsheet.last_row - 1).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        employee = row.to_hash
        temp_import_employee(
            employee["First Name"], employee["Last Name"], employee["Address 1"], employee["City"],
            employee["County"], employee["State"], employee["Zip Code"], employee["Username"],
            employee["Password"], employee["Mobile Phone"], employee["Email"], employee["Designation"], service_provider_id
        )
      end
    end
  end

  def self.temp_import_employee(fname, lname, address, city, county, state, zip, username, password, phone, email, designation, cmp_id)
    hash = {
        first_name: fname,
        last_name: lname,
        address: address,
        city: city,
        county: county,
        state: state.present? ? state.upcase : state,
        zip: zip.to_s.split('.').first,
        username: username,
        password: password,
        phone_number: phone.to_s,
        email: email,
        company_id: cmp_id
    }
    employee = Employee.new(hash)
    new_array = employee.attributes.delete_if { |k, v| !v.nil? }.keys
    new_array.push('distance')

    existing_emp = Employee.where(company_id: cmp_id, email: email)
    if existing_emp.count > 0
      unless existing_emp.first.attributes.except(*new_array) == employee.attributes.except(*new_array)
        hash[:status]= 1
        EmployeeImport.create(hash)
      end
    else
      hash[:status]= 0
      EmployeeImport.create(hash)
    end
  end

  def self.import(file, service_provider_id)
    if file.content_type.split('/').second == 'csv'
      CSV.foreach(file.path, headers: true) do |row|
        employee = row.to_hash
        new_import_employee(
            employee["First Name"], employee["Last Name"], employee["Address"], employee["City"],
            employee["County"], employee["State"], employee["Zip"], employee["Username"],
            employee["Password"], employee["Phone Number"], employee["Email"], employee["Designation"], service_provider_id
        )
      end
    else
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        employee = row.to_hash
        new_import_employee(
            employee["First Name"], employee["Last Name"], employee["Address"], employee["City"],
            employee["County"], employee["State"], employee["Zip"], employee["Username"],
            employee["Password"], employee["Phone Number"], employee["Email"], employee["Designation"], service_provider_id
        )
      end
    end
  end

  def self.new_import_employee(fname, lname, address, city, county, state, zip, username, password, phone, email, designation, cmp_id)
    employee = Employee.where(
        first_name: fname,
        last_name: lname,
        address: address,
        city: city,
        county: county,
        state: state,
        zip: zip.to_s.split('.').first,
        username: username,
        password: password,
        phone_number: phone.to_s,
        email: email,
        designation_id: Designation.find_by_name(designation),
        company_id: cmp_id
    ).first_or_create
    begin
      coordinates = Geokit::Geocoders::GoogleGeocoder.geocode("#{employee.address} ,#{employee.city}, #{employee.county}, #{employee.state} #{employee.zip}")
      employee.base_latitude = coordinates.lat
      employee.base_longitude = coordinates.lng
      p 'Geocoded Successfully'
    rescue Exception => e
      p e
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def selected_attributes
    self.attributes.except('created_at', 'updated_at', 'id', 'distance')
  end

  def get_address
  end

  private

  def before_save_data
    unless new_record?
      self.distance = distance_to_company
    end
  end

  def no_nil(val)
    return val unless val == nil
    0
  end

end
