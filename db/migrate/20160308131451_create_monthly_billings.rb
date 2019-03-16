class CreateMonthlyBillings < ActiveRecord::Migration
  def change
    create_table :monthly_billings do |t|
      t.integer :company_id
      t.integer :month
      t.integer :year
      t.text :employee_ids
      t.integer :employees_count
      t.float :base_fee
      t.float :employee_fee
      t.float :reach_out_fee
      t.float :transfer_fee
      t.float :amount_due

      t.timestamps
    end
  end
end
