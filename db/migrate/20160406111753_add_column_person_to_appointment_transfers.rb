class AddColumnPersonToAppointmentTransfers < ActiveRecord::Migration
  def change
    add_column :appointment_transfers, :person, :string
    add_column :appointment_transfers, :transfer_type, :integer
    add_column :appointment_transfers, :person_id, :integer
    add_column :appointment_transfers, :document, :text
  end
end
