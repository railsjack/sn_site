class AddFollowerToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :follower, index: true
  end
end
