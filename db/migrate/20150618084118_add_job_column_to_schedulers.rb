class AddJobColumnToSchedulers < ActiveRecord::Migration
  def change
    add_column :schedulers, :job_id, :text
  end
end
