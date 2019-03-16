class CreateEmployeeLovedones < ActiveRecord::Migration
  def change
    create_table :employee_lovedones do |t|
      t.integer :employee_id
      t.integer :lovedone_id

      t.timestamps
    end
  end
end
