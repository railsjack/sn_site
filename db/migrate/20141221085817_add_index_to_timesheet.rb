class AddIndexToTimesheet < ActiveRecord::Migration
  def change
	  add_index :timesheets, :company_id
	  add_index :timesheets, :employee_id
	  add_index :timesheets, :lovedone_id
	  add_index :timesheets, :provider_id
  end
end
