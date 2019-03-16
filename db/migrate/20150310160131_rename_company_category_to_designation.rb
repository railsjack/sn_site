class RenameCompanyCategoryToDesignation < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? 'designations' and ActiveRecord::Base.connection.table_exists? 'company_categories'
      drop_table :designations
      rename_table :company_categories, :designations
    elsif ActiveRecord::Base.connection.table_exists? 'company_categories'
      rename_table :company_categories, :designations
    end
  end
end
