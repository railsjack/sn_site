class AddEncounterBasedColumnToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :encounter_based, :boolean, default: false
  end
end
