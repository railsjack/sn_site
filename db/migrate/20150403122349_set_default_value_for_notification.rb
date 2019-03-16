class SetDefaultValueForNotification < ActiveRecord::Migration
  def change
    change_column :companies, :get_notification, :boolean, default: false
  end
end
