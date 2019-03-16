class AddCountyToLovedones < ActiveRecord::Migration
  def change
  	add_column :lovedones, :county, :string
  end
end
