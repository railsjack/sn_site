module EmployeesHelper
  def coordinates_location(lat,lng,active_trip)
    begin
        active_location = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lng}"
        active_location.full_address
        trip = active_trip
        trip.address = active_location.full_address
        trip.count = 1
        trip.save
        active_location.full_address
    rescue
      # do nothing
    end
  end

  def mileage_calculation(start_lat, start_lng, end_lat, end_lng)
    begin
      result = Geocoder::Calculations.distance_between([start_lat,start_lng], [end_lat,end_lng])
      return result
    rescue
      # do nothing
    end
  end

  def current_employee_address(start_lat, start_lng, end_lat, end_lng)
    begin
      url = URI.parse('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+start_lat.to_s+','+start_lng.to_s+'&destinations='+end_lat.to_s+','+end_lng.to_s+'&mode=driving&language=en-EN')
      req = Net::HTTP::Get.new(url.request_uri)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")
      res = http.request(req)
      result = JSON.parse(res.body);

      return result
    rescue

    end
  end

  def self.base_distance(start_lat, start_lng, end_lat, end_lng)
    # &key=AIzaSyD4TEl1DR6He96UuLYsUIQPUOaBOM-PXVw
    url = URI.parse('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+start_lat.to_s+','+start_lng.to_s+'&destinations='+end_lat.to_s+','+end_lng.to_s+'&mode=driving&language=en-EN')
    req = Net::HTTP::Get.new(url.request_uri)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    res = http.request(req)
    result = JSON.parse(res.body);

    return result['rows'][0]['elements']
  end
end
