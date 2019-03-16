class CreateSponsorMessages < ActiveRecord::Migration
  def change
    create_table :sponsor_messages do |t|
      t.integer :sponsor_id
      t.integer :employee_id
      t.integer :lovedone_id
      t.integer :company_id
      t.integer :follower_id
      t.datetime :date

      t.timestamps
    end
  end
end
