class AddFieldsToSponsors < ActiveRecord::Migration
  def change
  	add_column :sponsors, :company_name, :string
  	add_column :sponsors, :city, :string
  	add_column :sponsors, :state, :string
  	add_column :sponsors, :zip, :string
  	add_column :sponsors, :phone, :string
  	add_column :sponsors, :email, :string
  	add_column :sponsors, :mobile_phone_number, :string
  	add_column :sponsors, :contact_last_name, :string
  	add_column :sponsors, :contact_first_name, :string
  	add_column :sponsors, :sponsor_ship_type, :string
  end
end
