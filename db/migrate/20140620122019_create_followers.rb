class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.references :user, index: true
      t.references :lovedone, index: true
      t.string :request_status

      t.timestamps
    end
  end
end
