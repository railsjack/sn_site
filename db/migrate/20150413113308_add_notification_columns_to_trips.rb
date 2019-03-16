class AddNotificationColumnsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :distance_notification, :datetime
    add_column :trips, :time_notification, :datetime
    add_column :trips, :recurring_notification, :datetime
    add_column :trips, :early_arrival_notification, :datetime
    add_column :trips, :notification_response, :boolean, default: false
  end
end
