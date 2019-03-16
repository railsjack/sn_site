class AddDeletedAtToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :deleted_at, :datetime
    add_index :lovedones, :deleted_at
  end
end
