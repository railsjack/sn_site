class AddColumnsToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :device_type, :string
    add_column :employees, :device_id, :text
  end
end
