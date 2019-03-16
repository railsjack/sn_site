class AddDistanceToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :distance, :decimal, precision: 8, scale: 2, default: 0
  end
end
