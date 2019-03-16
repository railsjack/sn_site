class AddColumnsToFollowers < ActiveRecord::Migration
  def change
    add_column :followers, :apt_unit, :string
    add_column :followers, :street, :string
    add_column :followers, :city, :string
    add_column :followers, :county, :string
    add_column :followers, :state, :string
    add_column :followers, :zip_code, :string
    add_column :followers, :setting, :integer, default: 0
  end
end
