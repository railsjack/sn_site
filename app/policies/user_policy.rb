class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.admin?
    #if @current_user.company
    #   @current_user.company.approved? 
    #end    
  end

  def show?
    @current_user.admin? or @current_user == @user
  end

  def edit?
    @current_user.admin?
  end

  def update?
    @current_user.admin?
  end

  def update_by_admin?
    @current_user.admin?
  end

  def dashboard?
    @current_user.admin? or @current_user.role=="serviceprovider"
  end
    
  def providers?
    @current_user.admin?
  end
    
  def admins?
    @current_user.admin?
  end
    
  def destroy?
    return false if @current_user == @user
    @current_user.admin?
  end

  def testp?
    @current_user.admin? or @current_user.role=="serviceprovider"
  end

end
