class CreateAccessSettings < ActiveRecord::Migration
  def change
    create_table :access_settings do |t|
      t.integer :user_id
      t.integer :tab_id

      t.timestamps
    end
  end
end
