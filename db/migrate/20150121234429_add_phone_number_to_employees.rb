class AddPhoneNumberToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :phone_number, :string
  end
end
