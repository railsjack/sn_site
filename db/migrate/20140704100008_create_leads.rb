class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :name
      t.string :email
      t.references :profile, index: true

      t.timestamps
    end
  end
end
