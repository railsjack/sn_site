class ChangeMessageFeeToFloatInSponsors < ActiveRecord::Migration
  def change
  	change_column :sponsors, :messagefee, :decimal, precision: 8, scale: 2
  end
end
