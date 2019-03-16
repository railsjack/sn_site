class AddCountyToSponsors < ActiveRecord::Migration
  def change
  	add_column :sponsors, :county, :string
  end
end
