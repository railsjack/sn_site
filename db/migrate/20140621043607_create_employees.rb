class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.float :latitude
      t.float :longitude
      t.references :company, index: true
      t.references :lovedone, index: true
      t.string :name
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
