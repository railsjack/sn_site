class AddSponsorIdToNotification < ActiveRecord::Migration
  def change
  	add_column :notifications, :sponsor_id, :integer
  end
end
