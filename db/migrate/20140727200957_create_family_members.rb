class CreateFamilyMembers < ActiveRecord::Migration
  def change
    create_table :family_members do |t|
      t.string :lastname
      t.string :firstname
      t.string :email
      t.string :mobilephone
      t.string :contact
      t.integer :city
      t.integer :county
      t.integer :state
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
