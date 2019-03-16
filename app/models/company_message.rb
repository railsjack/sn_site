class CompanyMessage < ActiveRecord::Base
	has_many :company_message_employees, dependent: :destroy
	belongs_to :company

	validates :message, :presence=>true
	#validates :company_message_employees, :presence=>true
  #accepts_nested_attributes_for :company_message_employees
end

