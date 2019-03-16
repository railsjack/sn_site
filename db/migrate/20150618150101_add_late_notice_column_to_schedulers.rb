class AddLateNoticeColumnToSchedulers < ActiveRecord::Migration
  def change
    add_column :schedulers, :late_notice, :datetime
  end
end
