class EmployeeImport < ActiveRecord::Base
  validates :first_name, presence: true

  enum status: [:new_, :updated]
end
