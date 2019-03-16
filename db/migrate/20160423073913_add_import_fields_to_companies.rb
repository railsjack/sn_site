class AddImportFieldsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :employee_spoke, :integer
    add_column :companies, :lovedone_spoke, :integer
  end
end
