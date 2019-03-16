class AddDeletedAtToSchedulers < ActiveRecord::Migration
  def change
    add_column :schedulers, :deleted_at, :datetime
    add_index :schedulers, :deleted_at
  end
end
