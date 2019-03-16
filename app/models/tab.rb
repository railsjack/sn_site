class Tab < ActiveRecord::Base
  has_many :users, dependent: :destroy
end
