class AddTravelColumnsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :travel_time, :float
    add_column :trips, :travel_distance, :float
    add_column :trips, :lb_travel_distance, :float
    add_column :trips, :lb_travel_time, :float
  end
end
