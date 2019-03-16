class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :business_name
      t.string :provider_type
      t.string :telephone
      t.string :mobile_phone_number
      t.boolean :get_notification
      t.integer :user_id
      t.string :address
      t.string :city
      t.string :country
      t.string :state
      t.string :zip
      t.string :contact_last_name
      t.string :contact_first_name

      t.timestamps
    end
  end
end
