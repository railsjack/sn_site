class ChangeTrips < ActiveRecord::Migration
  def change
  	change_column :trips, :longitude, :string
  	change_column :trips, :latitude, :string
  end
end
