class AddCompanyCategoryIdToEmployee < ActiveRecord::Migration
  def change
  	add_column :employees, :company_category_id, :integer
  end
end
