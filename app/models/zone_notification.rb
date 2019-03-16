class ZoneNotification < ActiveRecord::Base
  belongs_to :company
  serialize :contact_method

  private
  def self.contact_types
    return  ["email","text"]
  end
end
