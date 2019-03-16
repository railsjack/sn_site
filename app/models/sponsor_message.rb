class SponsorMessage < ActiveRecord::Base
  belongs_to :sponsor
  belongs_to :employee
  belongs_to :lovedone
  belongs_to :company
  belongs_to :follower
end
