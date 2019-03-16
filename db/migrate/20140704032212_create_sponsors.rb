class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.text :address
      t.string :message

      t.timestamps
    end
  end
end
