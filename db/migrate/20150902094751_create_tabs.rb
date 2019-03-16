class CreateTabs < ActiveRecord::Migration
  def change
    create_table :tabs do |t|
      t.text :name

      t.timestamps
    end
  end
end
