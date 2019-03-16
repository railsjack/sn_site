class AddDefaultToEmployees < ActiveRecord::Migration
  def change
  	change_column :employees, :latitude, :double, default: 0
  	change_column :employees, :longitude, :double, default: 0
  end
end
