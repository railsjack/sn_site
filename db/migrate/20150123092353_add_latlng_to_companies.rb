class AddLatlngToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :latitude, :double
  	add_column :companies, :longitude, :double
  end
end
