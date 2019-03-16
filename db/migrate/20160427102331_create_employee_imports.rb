class CreateEmployeeImports < ActiveRecord::Migration
  def change
    create_table :employee_imports do |t|
      t.integer  :company_id
      t.string   :first_name
      t.string   :last_name
      t.string   :phone_number
      t.string   :address
      t.string   :state
      t.string   :county
      t.string   :city
      t.string   :zip
      t.string   :email
      t.string   :username
      t.string   :password
      t.string   :designation_id
      t.integer  :status
      t.timestamps
    end
  end
end
