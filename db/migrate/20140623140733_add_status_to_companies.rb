class AddStatusToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :status, :boolean
  end
end
