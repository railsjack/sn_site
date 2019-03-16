class AddUserColumnToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :user_id, :integer
    add_column :users, :username, :string
  end
end
