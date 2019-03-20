class Trip < ActiveRecord::Base
  belongs_to :employee
  belongs_to :lovedone
  has_one :timesheet, dependent: :destroy

  def current_address
    latitude = end_latitude
    longitude = end_longitude
    if latitude and longitude
      results = Geocoder.search([latitude, longitude])
      return if results.length == 0
      return results.first.address
    end
  end


end
