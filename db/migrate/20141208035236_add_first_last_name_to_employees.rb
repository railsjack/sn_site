class AddFirstLastNameToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :first_name, :string
  	add_column :employees, :last_name, :string
  	rename_column :employees, :name, :name_no_use
  end
end
