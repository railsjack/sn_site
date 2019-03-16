class CreateSponsorTypes < ActiveRecord::Migration
  def change
    create_table :sponsor_types do |t|
      t.integer :sponsor_id
      t.string :type
      t.string :name

      t.timestamps
    end
  end
end
