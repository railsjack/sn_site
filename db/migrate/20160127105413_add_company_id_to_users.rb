class AddCompanyIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer
    add_column :users, :admin, :boolean, default: false
    remove_column :companies, :user_id, :integer
  end
end
