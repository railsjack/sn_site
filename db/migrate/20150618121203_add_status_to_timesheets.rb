class AddStatusToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :status, :integer, default: 0
  end
end
