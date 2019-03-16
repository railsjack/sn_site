class AddCsvImportedToLovedones < ActiveRecord::Migration
  def change
  	add_column :lovedones, :csv_imported, :boolean, default: false
  end
end
