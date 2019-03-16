class AddNationToSponsors < ActiveRecord::Migration
  def change
  	add_column :sponsors, :nation, :string, default: 'US'
  end
end
