class AddEmployeeIdToLovedones < ActiveRecord::Migration
  def change
  	add_column :lovedones, :employee_id, :integer
  end
end
