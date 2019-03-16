class AddCompanyColumnToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :company_id, :integer
  end
end
