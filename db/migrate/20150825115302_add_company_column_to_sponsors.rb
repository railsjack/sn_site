class AddCompanyColumnToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :company_id, :integer
  end
end
