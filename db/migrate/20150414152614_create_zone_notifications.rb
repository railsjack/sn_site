class CreateZoneNotifications < ActiveRecord::Migration
  def change
    create_table :zone_notifications do |t|
      t.integer :company_id
      t.string :contact_method
      t.string :email
      t.string :phone_number
      t.float :distance_threshold
      t.float :time_threshold
      t.float :recurring_threshold
      t.boolean :system_status, default: true
      t.boolean :early_arrival_status, default: false

      t.timestamps
    end
  end
end
