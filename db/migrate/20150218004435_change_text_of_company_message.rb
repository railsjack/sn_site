class ChangeTextOfCompanyMessage < ActiveRecord::Migration
  def change
  	change_column :company_messages, :message, :text
  end
end
