class AddColumnToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :operation_mode, :string
  end
end
