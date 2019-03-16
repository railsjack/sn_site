class AddBaseColumnToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :base_to_first, :boolean, default: false
  end
end
