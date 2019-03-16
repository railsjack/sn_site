class CreateSchedulers < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.integer :lovedone_id
      t.integer :employee_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
