class AddPhoneColumnToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :phone_number, :string
  end
end
