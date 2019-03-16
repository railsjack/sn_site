class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :employee_id
      t.boolean :shift_started, default: false
      t.boolean :shift_completed, default: false
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
