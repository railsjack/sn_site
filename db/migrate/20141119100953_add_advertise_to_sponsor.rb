class AddAdvertiseToSponsor < ActiveRecord::Migration
  def change
  	add_column :sponsors, :advertise, :boolean, default: false
  end
end
