class CreateTravelLogs < ActiveRecord::Migration
  def change
    create_table :travel_logs do |t|
      t.float :latitude
      t.float :longitude
      t.integer :employee_id

      t.timestamps
    end

    rename_column :trips, :latitude, :end_latitude
    rename_column :trips, :longitude, :end_longitude
    add_column :trips, :start_latitude, :string
    add_column :trips, :start_longitude, :string

  end
end
