class CreateCompanyMessageEmployees < ActiveRecord::Migration
  def change
    create_table :company_message_employees do |t|
      t.integer :company_message_id
      t.integer :employee_id

      t.timestamps
    end
  end
end
