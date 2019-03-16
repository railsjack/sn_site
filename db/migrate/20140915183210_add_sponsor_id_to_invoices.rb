class AddSponsorIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :sponsor_id, :integer
  end
end
