class AddPrimaryContactToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :primary_contact, index: true
  end
end
