class AddPasswordFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :existing_password, :text
  end
end
