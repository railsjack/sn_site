class Notification < ActiveRecord::Base
  belongs_to :employee
  belongs_to :lovedone
  belongs_to :follower
  belongs_to :primary_contact
  belongs_to :sponsor
end
