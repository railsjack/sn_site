class AddFrequencyColumnsToSchedulers < ActiveRecord::Migration
  def change
    add_column :schedulers, :frequency, :integer
    add_column :schedulers, :key, :text
  end
end
