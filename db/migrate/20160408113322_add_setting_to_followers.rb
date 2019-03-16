class AddSettingToFollowers < ActiveRecord::Migration
  def change
    add_column :followers, :contact_method_setting, :integer, default: 0
  end
end
