class AddFieldsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :notification_masking, :boolean, default: false
    add_column :companies, :lovedone_masking, :boolean, default: false
  end
end
