class AddMessageCountToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :message_count, :integer
  end
end
