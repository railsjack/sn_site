class CreateEmployeeCompanyCategories < ActiveRecord::Migration
  def change
    create_table :employee_company_categories do |t|
    	t.integer :employee_id
    	t.integer :company_category_id
      t.timestamps
    end
  end
end
