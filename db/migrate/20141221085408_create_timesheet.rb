class CreateTimesheet < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
			t.datetime :starttime
			t.datetime :endtime
			t.integer  :lovedone_id
			t.integer  :employee_id
			t.integer  :company_id
			t.integer  :provider_id
			t.datetime :created_at
			t.datetime :updated_at

    end
  end
end
