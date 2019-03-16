class ChangeContactMethodToArray < ActiveRecord::Migration
  def change
      change_column :profiles, :contact_method, :text
  end
end
