class AddUserTypeToProfile < ActiveRecord::Migration
  def change
  	add_column :profiles, :user_type, :integer, :default=>0
  end
end
