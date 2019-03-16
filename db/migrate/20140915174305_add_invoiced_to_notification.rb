class AddInvoicedToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :invoiced, :boolean, :default => false
  end
end
