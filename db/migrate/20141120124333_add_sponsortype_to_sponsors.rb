class AddSponsortypeToSponsors < ActiveRecord::Migration
  def change
  	add_column :sponsors, :sponsortype, :string
  end
end
