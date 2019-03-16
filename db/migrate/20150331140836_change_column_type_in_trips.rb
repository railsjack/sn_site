class ChangeColumnTypeInTrips < ActiveRecord::Migration
  def change
    change_column :trips, :start_latitude, :float
    change_column :trips, :start_longitude, :float
    change_column :trips, :end_latitude, :float
    change_column :trips, :end_longitude, :float
  end
end
