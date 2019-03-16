class AddDefaultToCompanies < ActiveRecord::Migration
  def change
  	change_column :companies, :latitude, :double, default: 0
  	change_column :companies, :longitude, :double, default: 0
  end
end
