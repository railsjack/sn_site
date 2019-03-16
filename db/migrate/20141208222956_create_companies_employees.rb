class CreateCompaniesEmployees < ActiveRecord::Migration
  def change
    create_table :companies_employees do |t|
    	t.integer :company_id
    	t.integer :employee_id
    end
  end
end
