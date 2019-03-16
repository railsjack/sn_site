class AddFieldsToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :address, :text
    add_column :trips, :count, :int, default: 0
  end
end
