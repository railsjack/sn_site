class RenameEmployeesCompanyCategoryIdToDesignationId < ActiveRecord::Migration
  def change
    rename_column :employees, :company_category_id, :designation_id
  end
end
