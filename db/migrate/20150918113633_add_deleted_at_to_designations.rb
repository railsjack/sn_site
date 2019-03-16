class AddDeletedAtToDesignations < ActiveRecord::Migration
  def change
    add_column :designations, :deleted_at, :datetime
    add_index :designations, :deleted_at
  end
end
