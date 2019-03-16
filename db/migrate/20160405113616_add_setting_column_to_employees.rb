class AddSettingColumnToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :setting, :integer, default: 0
  end
end
