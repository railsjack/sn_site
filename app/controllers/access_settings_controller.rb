class AccessSettingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :read, AccessSetting
    @access_setting = AccessSetting.new
  end

  def new_member
    @email_exist = false
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    password = params[:password]

    existing_email = User.where(email: email)
    if existing_email.count > 0
      @email_exist = true
    else
      user = User.create(email: email, password: password, password_confirmation: password, existing_password: password, role: 1, confirmed_at: Time.now, admin: false, company: current_user.company)
      Tab.all.each do |tab|
        user.access_settings.create(tab: tab)
      end
      profile = user.build_profile(first_name: first_name, last_name: last_name)
      profile.save
      # member = current_user.company.users.new
      # member.user = user
      # member.admin = false
      # member.save
    end
  end

  def edit_member
    @user = User.find(params[:user_id])
  end

  def update_member
    @email_exist = false
    email = params[:email]
    user = User.find(params[:user_id])
    unless user.email.eql?(email)
      existing_email = User.where(email: email)
      if existing_email.count > 0
        @email_exist = true
      end
    end
    first_name = params[:first_name]
    last_name = params[:last_name]
    password = params[:password]
    user.email = email
    user.password = user.password_confirmation = user.existing_password = password if password.present?
    user.skip_reconfirmation!
    user.save
    profile = user.profile
    profile.first_name, profile.last_name  = first_name, last_name
    profile.save
  end

  def delete_member
    member_id = params[:member_id]
    user_id = params[:user_id]
    # CompanyMember.delete member_id
    User.destroy user_id
  end

  def update_access
    user = params[:access_setting][:user]
    AccessSetting.where(user_id: user).destroy_all
    params[:access_setting][:tab].each do |tab|
      if tab.present?
          AccessSetting.create(user_id: user, tab_id: tab)
      end
    end
  end

  def member_history
    user = User.find(params[:user_id])
    start_date = DateTime.strptime(params[:start_date], '%m/%d/%Y')
    end_date = DateTime.strptime(params[:end_date], '%m/%d/%Y')
    # @audits = user.audits.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    @audits = Audited::Adapters::ActiveRecord::Audit.where(created_at: start_date.beginning_of_day..end_date.end_of_day).where("(auditable_type='User' AND auditable_id=?) OR user_id=?", user.id, user.id).reorder("created_at")
  end

  def selected_history
    start_date = DateTime.strptime(params[:start_date], '%m/%d/%Y')
    end_date = DateTime.strptime(params[:end_date], '%m/%d/%Y')
    type = params[:type]
    case type
      when '0'
        type = ''
      when '1'
        type = 'Employee'
      when '2'
        type = 'Lovedone'
      when '3'
        type = 'Follower'
      when '4'
        type = 'Scheduler'
      when '5'
        type = 'System'
    end

    members_id = current_user.company.users.where(admin: false).pluck(:id)

    @audits = Audited::Adapters::ActiveRecord::Audit.where(user_id: members_id,created_at: start_date.beginning_of_day..end_date.end_of_day).reorder("created_at")

    if type.eql?('System')
      @audits = @audits.where(auditable_type: 'User', action: 'update').reorder("created_at")
    elsif type.present?
      @audits = @audits.where(auditable_type: type).reorder("created_at")
    end
  end
end
