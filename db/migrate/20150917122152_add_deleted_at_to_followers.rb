class AddDeletedAtToFollowers < ActiveRecord::Migration
  def change
    add_column :followers, :deleted_at, :datetime
    add_index :followers, :deleted_at
  end
end
