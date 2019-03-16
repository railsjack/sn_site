class AddColumnsToMonthlyBillings < ActiveRecord::Migration
  def change
    add_column :monthly_billings, :reach_out_count, :integer
    add_column :monthly_billings, :transfer_count, :integer
  end
end
