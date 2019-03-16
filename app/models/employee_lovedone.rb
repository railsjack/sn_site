class EmployeeLovedone < ActiveRecord::Base
  belongs_to :lovedone
  belongs_to :employee
end
