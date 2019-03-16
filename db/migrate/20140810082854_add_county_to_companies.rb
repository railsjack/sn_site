class AddCountyToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :county, :string
  end
end
