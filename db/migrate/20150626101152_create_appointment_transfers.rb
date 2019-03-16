class CreateAppointmentTransfers < ActiveRecord::Migration
  def change
    create_table :appointment_transfers do |t|
      t.text :ids
      t.integer :transfer_count
      t.datetime :transfer_date
      t.integer :company_id

      t.timestamps
    end
  end
end
