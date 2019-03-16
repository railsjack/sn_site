class User < ActiveRecord::Base
  audited
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile, :allow_destroy => true

  has_one :employee

  has_many :emails, as: :emailable
  accepts_nested_attributes_for :emails, reject_if: :all_blank, allow_destroy: true

  belongs_to :company
  accepts_nested_attributes_for :company
    
  has_many :followers
  has_many :lovedones, through: :company
  accepts_nested_attributes_for :lovedones

  has_many :access_settings, dependent: :destroy
  has_many :tabs, through: :access_settings

  attr_accessor :current_password, :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum role: [:user, :serviceprovider, :admin, :employee, :family_member]
  enum selected_page: [:accounts, :providers, :admins]

  validates_acceptance_of :terms

  after_initialize :set_default_role, :if => :new_record?
  before_destroy :destroy_company

  def destroy_company
    if self.admin
      self.company.destroy
    end
  end

  def set_default_role
    self.role ||= :user
  end

  def send_on_create_confirmation_instructions
  end

  def send_on_create_confirmation_instructions_ex
    send_confirmation_instructions
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def self.search(search)
    searchrole = "0"
    if search
      where('name LIKE ? AND role = ?', "%#{search}%", searchrole)
    else
      where('role = ?',searchrole)
    end
  end

  def self.users_with_company
      User.joins("LEFT OUTER JOIN profiles ON profiles.user_id = users.id").where("profiles.id IS null")
  end

  def self.users_with_profile
      User.joins("LEFT OUTER JOIN profiles ON profiles.user_id = users.id").where("profiles.id IS NOT null")
  end

  def email_required?
    false
  end

  def name
    "#{profile.last_name}, #{profile.first_name}" unless profile.nil?
  end

  def provider?
    role=="serviceprovider"
  end
end
