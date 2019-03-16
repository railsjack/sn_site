class AddEmailAndSettingToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :email, :string
    add_column :lovedones, :setting, :integer, default: 0
  end
end
