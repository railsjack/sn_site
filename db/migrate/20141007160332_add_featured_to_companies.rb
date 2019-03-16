class AddFeaturedToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :featured, :boolean, default: false
  end
end
