class AddContactMethodToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :contact_method, :string
  end
end
