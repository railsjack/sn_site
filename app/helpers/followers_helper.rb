module FollowersHelper
  def self.valid?(phone_number)
    lookup_client = Twilio::REST::LookupsClient.new(Rails.application.secrets.twilio_sid, Rails.application.secrets.twilio_token)
    begin
      response = lookup_client.phone_numbers.get(phone_number)
      response.phone_number #if invalid, throws an exception. If valid, no problems.
      return true
    rescue => e
      if e.code == 20404
        return false
      else
        raise e
      end
    end
  end
end
