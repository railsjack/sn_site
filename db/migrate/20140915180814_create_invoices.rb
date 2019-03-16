class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :title
      t.decimal :amount
      t.text :ids
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
