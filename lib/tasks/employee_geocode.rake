namespace :employee_geocode do
  task geocode_address: :environment do
    Employee.where("username LIKE '%16dyna%'").each do |employee|
      p '-'*100
      if employee.base_latitude.nil? and employee.base_longitude.nil?
        if employee.city.present? and employee.state.present? and employee.address.present?
          begin
            coordinates = Geokit::Geocoders::GoogleGeocoder.geocode("#{employee.address} ,#{employee.city}, #{employee.county}, #{employee.state} #{employee.zip}")
            employee.base_latitude = coordinates.lat
            employee.base_longitude = coordinates.lng
            employee.save
            p 'Geocoded Successfully'
          rescue Exception => e
            p e
          end
        else
          p 'Address not present'
        end
      else
        p 'Already Gecocoded'
      end
    end
  end
end