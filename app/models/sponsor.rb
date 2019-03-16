class Sponsor < ActiveRecord::Base
	has_many :invoices
  has_many :sponsor_types
  has_many :sponsor_messages

  belongs_to :company

  accepts_nested_attributes_for :sponsor_types, allow_destroy: true

  scope :sms, -> {where(sponsortype: ['Both', 'Sponsor'])}
  scope :ads, -> {where(sponsortype: ['Both', 'Advertiser'])}

  validates :name, presence: true
  validates :state, uniqueness: true

  # has_attached_file :picture, :styles => { :medium => "300x300#", :thumb => "100x100#" }, :default_url => 'missing.png'
  # do_not_validate_attachment_file_type :picture

  def self.next(id)
    self.where("id > ?", id).order("id ASC").first || Sponsor.first
  end

  def self.previous(id)
    self.where("id < ?", id).order("id DESC").first || Sponsor.last
  end    

  def self.sponsortypes
      # return  ["Sponsor", "Advertiser", "Both"]
      return  ["Sponsor"]
  end

  def self.national_types
      # return  ["US", "State", "County"]
      return  ['County', 'State', 'National', 'Specific']
  end

  def contains_people?(people)
  	return true if self.state =='all'
  	return true if people.county == self.county
  	return true if people.state == self.state and self.county =='all'
  	return false
  end


end
