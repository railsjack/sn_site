class AddPhoneNumberToLeads < ActiveRecord::Migration
  def change
  	add_column :leads, :phone_number, :string
  end
end
