class AddEmailToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :email, :string
  end
end
