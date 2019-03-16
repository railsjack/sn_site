class AddRemoteIdToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :remote_id, :text
  end
end
