class AddFeeColumnsToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :employee_notice_fee, :float
    add_column :sponsors, :transfer_fee, :float
    add_column :sponsors, :employee_notice_status, :boolean, default: false
    add_column :sponsors, :transfer_status, :boolean, default: false
  end
end
