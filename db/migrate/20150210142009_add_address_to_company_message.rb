class AddAddressToCompanyMessage < ActiveRecord::Migration
  def change
  	add_column :company_messages, :address, :string
  end
end
