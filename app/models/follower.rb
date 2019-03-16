class Follower < ActiveRecord::Base
  audited except: [:deleted_at, :user_id, :request_status, :contact_method]
  acts_as_paranoid
  belongs_to :user
  belongs_to :lovedone

  has_many :sponsor_messages
  serialize :contact_method

  enum setting: [:off, :email, :letter]
  enum contact_method_setting: [:no_contact ,:contact_email, :contact_text, :both]

  before_create :send_message

  def name
    return first_name if last_name.blank?
    "#{last_name}, #{first_name}"
  end

  def full_name
    return first_name if last_name.blank?
    "#{first_name} #{last_name}"
  end

  def lovedone
    Lovedone.unscoped { super }
  end

  private
  def send_message
    require 'open-uri'
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token

    # unless self.email == ''
    if ['contact_email', 'both'].include? self.contact_method_setting
      confirmation_email = SystemMailer.follower_confirmation_email(self.email, self.lovedone)
      confirmation_email.deliver
    end

    # unless self.phone_number == ''
    if ['contact_text', 'both'].include? self.contact_method_setting
      to_number = self.phone_number
      if self.lovedone.company.notification_masking
        body = "Hello! This message is to inform you that #{self.lovedone.company.business_name} has added you to the contact list for their interaction with #{self.lovedone.first_name} #{self.lovedone.last_name[0]}. You will be notified during their future encounters. Thank you."
      else
        body = "Hello! This message is to inform you that #{self.lovedone.company.business_name} has added you to the contact list for their interaction with #{self.lovedone.first_name} #{self.lovedone.last_name}. You will be notified during their future encounters. Thank you."
      end

      to_number = to_number.gsub(/\D/, "")
      if to_number.size == 10
        to_number = '+1' + to_number

        begin
          if FollowersHelper.valid?(to_number)
            @client.messages.create(
                :from => Rails.application.secrets.twilio_from_number,
                :to => to_number,
                :body => body
            )
          else
            self.errors.add(:phone_number, "Invalid Phone Number")
            return false
          end
        rescue => ex
          logger.error ex.message
        end
      end
    end
  end

  # validates_inclusion_of :request_status, :in => %w( invited requested approved )

  def is_invited
      where("request_status = ?",  "invited")
  end

  def self.contact_types
    return  ["email","text"]
  end
  
  def is_approved_follower(user)
      #self.find()
  end  
end
