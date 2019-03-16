namespace :lovedone_geocode do
  task geocode_address: :environment do
    Lovedone.all.each do |lovedone|
      p '-'*100
      if lovedone.latitude.nil? and lovedone.longitude.nil?
        if lovedone.city.present? and lovedone.state.present? and lovedone.street.present?
          begin
            coordinates = Geokit::Geocoders::GoogleGeocoder.geocode("#{lovedone.apt_unit} #{lovedone.street},#{lovedone.city}, #{lovedone.county}, #{lovedone.state} #{lovedone.zip_code}")
            lovedone.latitude = coordinates.lat
            lovedone.longitude = coordinates.lng
            lovedone.save
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