class Company < ActiveRecord::Base
    include Geokit::Geocoders
    
    default_scope {order('company_name ASC')}

    scope :featured, -> {where(featured: true)}
    scope :home_healths, -> {where(provider_type: 'Home_Health')}
    scope :transports, -> {where(provider_type: 'Transport')}

    has_many :designations, dependent: :destroy
    has_many :employees, dependent: :destroy
    has_many :company_messages
    has_many :lovedones, dependent: :destroy
    has_many :appointment_transfers
    has_many :sponsor_messages
    has_many :monthly_billings
    has_many :users

    has_one :zone_notification, dependent: :destroy
    has_one :late_notice_notification, dependent: :destroy
    has_one :fee, dependent: :destroy
    has_one :sponsor

    accepts_nested_attributes_for :fee, allow_destroy: true
    accepts_nested_attributes_for :zone_notification, allow_destroy: true
    accepts_nested_attributes_for :late_notice_notification, allow_destroy: true

    after_initialize :set_default_status, :if => :new_record?
    before_save :update_coordinates
    after_create :create_designations

    has_attached_file :picture, :styles => { :medium => "300x300#", :thumb => "100x100#" }, :default_url => 'missing.png'

    def contact_name
        return "#{contact_last_name}, #{contact_first_name}"
    end

    def self.contact_types
        return  ["email","text"]
    end

    serialize :contact_method

    def set_default_status
        self.status ||= :pending
    end

    def self.statuses
        [:pending, :approved]
    end

    def approved?
        self.status == "approved"
    end    

    def to_s
        self.company_name
    end  

    def pending?
        self.status == "pending"
    end

    def self.companies_awaiting
        where(status:'pending').count
    end

    def self.companies_with_transport
        where(provider_type:'Transport').count
    end

    def self.companies_with_home_health
        where(provider_type:'Home_Health').count
    end

    def self.provider_types
        return  [['Transport', 'Transport'],['Home Health','Home_Health']]
    end

    def update_coordinates
        begin
            if self.latitude.nil? or self.longitude.nil? or self.address_changed? or self.city_changed? or self.county_changed? or self.state_changed? or self.zip_changed?
                coordinates = Geokit::Geocoders::GoogleGeocoder.geocode("#{self.address}, #{self.city}, #{self.county}, #{self.state} #{self.zip} ")
                self.latitude = coordinates.lat
                self.longitude = coordinates.lng
            end
        rescue

        end
    end

    def employees_within(nmile)
        employees = []
        self.onlined_employees.each do |employee|
            emp_lat = employee.latitude
            emp_lng = employee.longitude
            emp_lat = 0 if emp_lat == nil
            emp_lng = 0 if emp_lng == nil

            puts [emp_lat, emp_lng, employee.inspect]
            distance = self.haversine_distance(emp_lat, emp_lng, latitude, longitude)
            employees << employee if distance <= nmile
        end
        employees
    end

    def haversine_distance( lat1, lon1, lat2, lon2 )
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

    def create_designations
        self.designations.create([{name:"RN",color:"Green"},{name:"LPN",color:"Blue"},{name:"CNA",color:"Brown"},{name:"Other",color:"Purple"}])
    end
end
