class CreateCompanyMembers < ActiveRecord::Migration
  def change
    create_table :company_members do |t|
      t.integer :company_id
      t.integer :user_id
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
