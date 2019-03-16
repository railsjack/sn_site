class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.references :employee, index: true
      t.references :lovedone, index: true
      t.string :status
      t.string :state
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
