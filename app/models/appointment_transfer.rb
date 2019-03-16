class AppointmentTransfer < ActiveRecord::Base
  belongs_to :company

  enum transfer_type: [:letter, :email, :text, :email_text]
end
