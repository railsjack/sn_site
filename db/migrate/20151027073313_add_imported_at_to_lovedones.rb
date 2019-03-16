class AddImportedAtToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :imported_at, :datetime
  end
end
