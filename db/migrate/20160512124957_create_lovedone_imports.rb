class CreateLovedoneImports < ActiveRecord::Migration
  def change
    create_table :lovedone_imports do |t|
      t.integer  :company_id
      t.string   :first_name
      t.string   :last_name
      t.string   :gender
      t.date   :date_of_birth
      t.string   :phone_number
      t.string   :apt_unit
      t.string   :street
      t.string   :state
      t.string   :county
      t.string   :city
      t.string   :zip_code
      t.string   :email
      t.integer  :status
      t.timestamps
    end
  end
end
