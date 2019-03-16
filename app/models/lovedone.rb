class Lovedone < ActiveRecord::Base
  audited except: [:latitude, :longitude, :deleted_at, :csv_imported, :primary_contact_id, :employee_id, :company_id, :nick_name, :country]
  acts_as_paranoid

  belongs_to :employee
  belongs_to :company

  has_many :sponsor_messages
  has_many :employee_lovedones
  has_many :schedulers, dependent: :destroy
  has_many :assigned_employees, through: :employee_lovedones, source: :lovedone
  has_many :followers , dependent: :destroy
  has_many :trips, dependent: :destroy
  has_many :active_trips,  -> { where("status = 'started' or status = 'active'")}, class_name: 'Trip'

  default_scope { order('last_name ASC') }

  scope :search_lovedones, ->(lovedone_ids) {where(id: lovedone_ids)}

  enum setting: [:off, :email, :letter]

  before_save :update_coordinates

  def update_coordinates
    begin
      if self.apt_unit_changed? or self.street_changed? or self.city_changed? or self.county_changed? or self.state_changed? or self.zip_code_changed?
        coordinates = Geokit::Geocoders::GoogleGeocoder.geocode("#{self.apt_unit} #{self.street},#{self.city}, #{self.county}, #{self.state} #{self.zip_code}")
        self.latitude = coordinates.lat
        self.longitude = coordinates.lng
      end
    rescue Exception => e
      p e
    end
  end

  def name
    return first_name if last_name.blank?
    "#{last_name}, #{first_name}"
  end

  def full_name
    return first_name if last_name.blank?
    "#{first_name} #{last_name}"
  end
  
  after_initialize do
    #self.primary_contact ||= self.build_primary_contact
  end
    
  def make_primary!(primary_user)
      self.primary_contact.user_id = primary_user.id
      self.primary_contact.lovedone_id = self.id
      self.primary_contact.save!()
  end
    
  def remove_primary!(primary_user)
      primary_contact.find_by(primary_contact_id: primary_user.id).destroy
  end    
    
  accepts_nested_attributes_for :followers, allow_destroy: true

  def is_primary_contact?(user)
      self.primary_contact.user_id == user.id
  end
  def is_follower?(user)
      self.followers.where("user_id = ?",user.id)
  end
  def get_invited(user)
      self.followers.where("request_status LIKE ? AND user_id = ?","invited", user.id)
  end

  def approved_followers
    followers.where(:request_status => "approved")
  end

  def self.axxess_import(file, service_provider_id)
    if file.content_type.split('/').second == 'csv'
      CSV.foreach(file.path, headers: true) do |row|
        lovedone = row.to_hash
        temp_import_lovedone(
            lovedone["First Name"], lovedone["Last Name"], lovedone["Gender"], lovedone["DOB"], lovedone["Address Line 1"], lovedone["Address Line 2"], lovedone["City"],
            lovedone["County"], lovedone["State"], lovedone["Zip Code"], lovedone["Phone"], lovedone["Email Address"], service_provider_id
        )
      end
    else
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(2)
      (3..spreadsheet.last_row - 1).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        lovedone = row.to_hash
        temp_import_lovedone(
            lovedone["First Name"], lovedone["Last Name"], lovedone["Gender"], lovedone["DOB"], lovedone["Address Line 1"], lovedone["Address Line 2"], lovedone["City"],
            lovedone["County"], lovedone["State"], lovedone["Zip Code"], lovedone["Phone"], lovedone["Email Address"], service_provider_id
        )
      end
    end
  end

  def self.temp_import_lovedone(fname, lname, gender, dob, street, apt_unit, city, county, state, zip, phone, email, cmp_id)
    if gender.eql? 'Male'
      boolean_gender = 'true'
    elsif gender.eql? 'Female'
      boolean_gender = 'false'
    end

    hash = {
        first_name: fname,
        last_name: lname,
        gender: boolean_gender,
        date_of_birth: dob,
        street: street,
        apt_unit: apt_unit,
        city: city,
        county: county.present? ? county.gsub(' County', '') : county,
        state: state,
        zip_code: zip.to_s.split('.').first,
        phone_number: phone.to_s,
        email: email,
        company_id: cmp_id
    }
    lovedone = Lovedone.new(hash)
    new_array = lovedone.attributes.delete_if { |k, v| !v.nil? }.keys

    existing_lo = Lovedone.where(company_id: cmp_id, first_name: fname, last_name: lname, phone_number: phone.to_s)
    if existing_lo.count > 0
      unless existing_lo.first.attributes.except(*new_array) == lovedone.attributes.except(*new_array)
        hash[:status]= 1
        LovedoneImport.create(hash)
      end
    else
      hash[:status]= 0
      LovedoneImport.create(hash)
    end
  end

  def self.import(file, service_provider_id)
    if file.content_type.split('/').second == 'csv'
      CSV.foreach(file.path, headers: true) do |row|
        lovedone = row.to_hash
        new_import_lovedone(
            lovedone["First Name"], lovedone["Last Name"], lovedone["Middle Initial"], lovedone["DOB"], lovedone["Sex"],
            lovedone["Phone Number"], lovedone["Street"], lovedone["Apartment/Unit #"], lovedone["City"], lovedone["County"],
            lovedone["State"], lovedone["Zip"], true, service_provider_id
        )
        end
    else
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        lovedone = row.to_hash
        new_import_lovedone(
            lovedone["First Name"], lovedone["Last Name"], lovedone["Middle Initial"], lovedone["DOB"], lovedone["Sex"],
            lovedone["Phone Number"], lovedone["Street"], lovedone["Apartment/Unit #"], lovedone["City"], lovedone["County"],
            lovedone["State"], lovedone["Zip"], true, service_provider_id
        )
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
    end
  end

  def self.new_import_lovedone(fname, lname, mi, dob, sex, phone, street, apt, city, county, state, zip, import, cmp_id)
    if sex.present?
      gender = sex=="M" ? "true" : "false"
    else
      gender = nil
    end
    lovedone = Lovedone.where(
        first_name: fname,
        last_name: lname,
        middle_initial: mi,
        date_of_birth:  dob.present? ? dob.strftime('%m-%d-%Y'): nil,
        gender: gender,
        phone_number: phone,
        street: street,
        apt_unit: if apt.is_a? Float
                    apt.to_i
                  else
                    apt
                  end,
        city: city,
        county: county,
        state: state,
        zip_code: if zip.is_a? Float
                    zip.to_i
                  else
                    zip
                  end,
        csv_imported: import,
        company_id: cmp_id
    ).first_or_create
  end

  def active_trip_updated
    if active_trips.first.count > 0
      return true
    else
      return false
    end
  end

end


