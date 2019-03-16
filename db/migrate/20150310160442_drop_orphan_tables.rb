class DropOrphanTables < ActiveRecord::Migration
  def self.up
    drop_table :employees_providers
    drop_table :companies_employees
    # drop_table :providers
    # drop_table :primary_contacts
  end

  def self.down
    puts "This migration can't be reverted"
  end
end
