class CompanyMessageEmployee < ActiveRecord::Base
  include Rails.application.routes.url_helpers
	belongs_to :company_message
	belongs_to :employee
	after_save :send_message


	private
	def send_message
    require 'open-uri'
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
    unless employee.phone_number.nil?
      map_url = URI::encode("http://maps.google.com/?q=#{company_message.address}")
      to_number = employee.phone_number
      body = "Notice From #{company_message.company.business_name}: 
#{company_message.message}
#{company_message.address}
#{map_url}"

      to_number = to_number.gsub(/\D/, "")
      if to_number.size == 10
        to_number = '+1' + to_number
        
        begin
          @client.messages.create(
            :from => Rails.application.secrets.twilio_from_number,
            :to => to_number,
            :body => body
          )
        rescue => ex
          logger.error ex.message
        end
        
      end
    end
	end
end

