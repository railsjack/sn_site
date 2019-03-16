class CreateLateNoticeNotifications < ActiveRecord::Migration
  def change
    create_table :late_notice_notifications do |t|
      t.integer :company_id
      t.string :contact_method
      t.string :email
      t.string :phone_number
      t.boolean :system_status, default: false
      t.float :time_threshold, default: 15
      t.timestamps
    end
  end
end
