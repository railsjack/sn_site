class AddMessagefeeSponsors < ActiveRecord::Migration
  def change
  	add_column :sponsors, :messagefee, :decimal
  end
end
