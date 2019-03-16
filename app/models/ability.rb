class Ability
  include CanCan::Ability

  def initialize(user)

    # Define abilities for the passed in user here. For example:
    #
      # user ||= User.new # guest user (not logged in)
      if user.serviceprovider? and !user.admin
        can :read, Employee if user.tabs.pluck(:name).include? 'Employees'
        can :read, Lovedone if user.tabs.pluck(:name).include? 'Loved Ones'
        can :read, Scheduler if user.tabs.pluck(:name).include? 'Scheduler'
        can :read, Company if user.tabs.pluck(:name).include? 'My Company'
        can :track, Employee if user.tabs.pluck(:name).include? 'Track'
        can :read_report, Employee if user.tabs.pluck(:name).include? 'Reports'
        can :read, DataImportsController if user.tabs.pluck(:name).include? 'Data Import'
        can :read, DataUploadsController if user.tabs.pluck(:name).include? 'Data Export'
        can :read, StaticPagesController if user.tabs.pluck(:name).include? 'Help'
        cannot :read, AccessSetting
      elsif user.employee?
        can :read, Scheduler
      else
        can :manage, :all
      end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
