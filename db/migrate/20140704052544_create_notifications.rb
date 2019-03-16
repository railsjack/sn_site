class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :employee, index: true
      t.references :lovedone, index: true
      t.string :status
      t.string :notification_type

      t.timestamps
    end
  end
end
