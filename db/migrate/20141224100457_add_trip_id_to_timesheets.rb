class AddTripIdToTimesheets < ActiveRecord::Migration
  def change
  	add_column :timesheets, :trip_id, :integer
  end
end
