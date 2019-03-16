class AddFieldsToFollowers < ActiveRecord::Migration
  def change
    add_column :followers, :first_name, :string
    add_column :followers, :last_name, :string
    add_column :followers, :email, :string
    add_column :followers, :phone_number, :string
  end
end
