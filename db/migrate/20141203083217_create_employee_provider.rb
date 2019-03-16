class CreateEmployeeProvider < ActiveRecord::Migration

  def change
    create_table :employees_providers do |t|
      t.integer :employee_id
      t.integer :provider_id

      t.timestamps
    end
  end
end

