class ChangeStatusTypeInCompany < ActiveRecord::Migration
  def change
      change_column :companies, :status, :string, :default => "pending", :nil => "pending"
  end
end
