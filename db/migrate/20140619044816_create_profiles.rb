class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_initial
      t.string :nick_name
      t.date :date_of_birth
      t.string :gender
      t.string :address
      t.string :city
      t.string :country
      t.string :state
      t.string :zip
      t.string :contact_method

      t.timestamps
    end
  end
end
