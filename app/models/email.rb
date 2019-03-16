class Email < ActiveRecord::Base
  belongs_to :emailable, polymorphic: true
  validates :email, uniqueness: true
end
