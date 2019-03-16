class AddZoneColumnToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :inside_zone, :boolean, default: false
  end
end
