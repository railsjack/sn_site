class AddServiceStatusToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :service_status, :string
  end
end
