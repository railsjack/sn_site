class EmployeeCompanyCategory < ActiveRecord::Base
	belongs_to :employee
	belongs_to :designation

	validates_uniqueness_of :employee_id, scope: :company_category_id
end
