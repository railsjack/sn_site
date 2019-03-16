class ChangeZoneColumns < ActiveRecord::Migration
  def change
    change_column :zone_notifications, :distance_threshold, :float, default: 0.5
    change_column :zone_notifications, :time_threshold, :float, default: 3
    change_column :zone_notifications, :recurring_threshold, :float, default: 30
  end
end
