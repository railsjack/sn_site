class AddCountyToProfile < ActiveRecord::Migration
  def change
  	add_column :profiles, :county, :string
  end
end
