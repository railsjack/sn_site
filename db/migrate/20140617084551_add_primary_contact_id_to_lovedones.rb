class AddPrimaryContactIdToLovedones < ActiveRecord::Migration
  def change
    add_column :lovedones, :primary_contact_id, :integer
  end
end
