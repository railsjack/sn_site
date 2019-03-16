class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.integer :company_id
      t.float :base_fee
      t.float :employee_fee
      t.float :reach_out_fee
      t.float :transfer_fee
      t.boolean :base_status, default: false
      t.boolean :employee_status, default: false
      t.boolean :reach_out_status, default: false
      t.boolean :transfer_status, default: false

      t.timestamps
    end
  end
end
