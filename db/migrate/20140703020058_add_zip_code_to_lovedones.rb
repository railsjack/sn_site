class AddZipCodeToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :zip_code, :string
  end
end
