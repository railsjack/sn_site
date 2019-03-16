class AddSelectedPageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :selected_page, :integer
  end
end
