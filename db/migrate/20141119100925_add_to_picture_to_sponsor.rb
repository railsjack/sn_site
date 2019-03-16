class AddToPictureToSponsor < ActiveRecord::Migration
  def change
    change_table :sponsors do |t|
      t.attachment :picture
    end
  end
end
