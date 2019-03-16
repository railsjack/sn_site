class AddBaseLocationFieldsToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :base_latitude, :float
    add_column :employees, :base_longitude, :float
  end
end
