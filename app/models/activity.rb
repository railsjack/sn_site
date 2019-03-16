class Activity < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
end
