class MonthlyBilling < ActiveRecord::Base
  belongs_to :company
  serialize :employee_ids
end
