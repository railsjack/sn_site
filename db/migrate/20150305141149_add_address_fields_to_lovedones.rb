class AddAddressFieldsToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :apt_unit, :string
    add_column :lovedones, :street, :string
  end
end
