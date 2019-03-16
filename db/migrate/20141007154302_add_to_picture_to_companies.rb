class AddToPictureToCompanies < ActiveRecord::Migration
  def change
    change_table :companies do |t|
      t.attachment :picture
    end
  end
end
