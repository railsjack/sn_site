class Trip < ActiveRecord::Base
  belongs_to :employee
  belongs_to :lovedone
  has_one :timesheet, dependent: :destroy
end
