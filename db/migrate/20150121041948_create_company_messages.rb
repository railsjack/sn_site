class CreateCompanyMessages < ActiveRecord::Migration
  def change
    create_table :company_messages do |t|
      t.integer :company_id
      t.string :message

      t.timestamps
    end
  end
end
