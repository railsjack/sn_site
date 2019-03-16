class AddDateColumnsToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :start_date, :datetime
    add_column :sponsors, :end_date, :datetime
  end
end
