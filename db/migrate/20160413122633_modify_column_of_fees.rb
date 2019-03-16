class ModifyColumnOfFees < ActiveRecord::Migration
  def change
    remove_column :fees, :transfer_fee, :float
    remove_column :fees, :transfer_status, :boolean
    add_column :fees, :transfer_fee, :float, default: 1.95
    add_column :fees, :transfer_status, :boolean, default: true
  end
end
