class AddDataUploadAlertColumnToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :abbreviated_time, :float, default: 15
  end
end
