class AddFieldsToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :latitude, :float
    add_column :lovedones, :longitude, :float
  end
end
