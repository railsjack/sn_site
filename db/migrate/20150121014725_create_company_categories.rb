class CreateCompanyCategories < ActiveRecord::Migration
  def change
    create_table :company_categories do |t|
      t.string :name
      t.string :color
      t.string :company_id

      t.timestamps
    end
  end
end
