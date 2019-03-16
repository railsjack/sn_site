namespace :company_address do
  task update_coordinates: :environment do
    Company.all.each do |c|
      if (c.latitude.nil? or c.latitude.zero?) or (c.longitude.nil? or c.longitude.zero?)
        coordinates = Geokit::Geocoders::GoogleGeocoder.geocode("#{c.address}, #{c.city}, #{c.county}, #{c.state} #{c.zip} ")
        c.update_attributes(latitude: coordinates.lat, longitude: coordinates.lng)
        p '*'*100
        p 'Saved Successfully'
        p '*'*100
      end
    end
  end
end